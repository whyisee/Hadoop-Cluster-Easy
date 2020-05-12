---

title: "大数据集群搭建005_4-zookeeper技术"
scp: 2020/5/9 7:35:40
tags: hadoop,zookeeper

---

# zookeeper技术

## 系统模型

## 数据模型

Zookeeper的视图结构和标准的unix文件系统非常类似  

**悲观锁**

又被称为悲观并发控制(Pessimistic Concurrent Control,PCC) 是数据库中一种非常典型的且严格的并发控制策略.  
其实现原理: 如果有一个事务正在对数据进行处理,那么整个处理的过程中都会将数据处于锁定状态,其他事务无法对这个数据进行更新操作.释放了对应的锁之后,其他事务才能重新竞争来对数据进行更新操作.  
悲观锁假定不同事务之间一定会有互相干扰.  

**乐观锁**

又被称为乐观并发控制(Optimistic Concurrency Control OCC) ,是一种非常常见的并发控制策略.  
原理: 每个事务都会首先检查当前事务读取数据后,是否有其他事务对改数据进行修改,如果有数据更新的话,那么正在提交的事务就会进行回滚.  

**CAS理论**

乐观锁的典型实现,对于值V,每次更新前都会对比其值是否是预期值A,只有符合预期,才会将V原子化更新到新值B.  

**zookeeper中使用version属性来实现乐观锁中的写入校验**

```java
//setData 请求版本检查
version = setDataRequest.getVersion();
int currentVersion = nodeRecord.stat.getVersion();
if(version != -1 && version != currentVersion){
    throw new KeeperException.BadVersionException(path);
}
version = currentVersion + 1;
```

### Watcher -- 数据变更的通知  

**工作机制**

客户端注册Watcher,服务端处理Watcher,客户端回调Watcher  

### ACL -- 保障数据安全

ACL:Access Control List  

UGO:User Group Other  

* 权限模式Schema  
* 授权对象ID
* 权限Permission  

通常使用"scheme:id:permission" 来表示一个有效的ACL信息  

#### Scheme

**IP**

如:
ip:192.168.0.111  
ip:192.168.0.1/24

**Disgist**

类似于"username:password"  

zookeeper会对该类型标识进行两次编码处理,分别是SHA-1和BASE64  
加密算法:
>DigestAuthenticationProvider.generateDigest("super:super");

**World**

最开放的一种权限控制模式,只有一个权限标识 "world:anyone"  

**Super**

超级用户  

#### Permission  

* CREATE(C)
* DELETE(D)
* READ(R)
* WRITE(W)
* ADMIN(A)

**扩展权限体系**  
实现AuthenticationProvider接口  
注册配置
>authProvider.1=com.xxx.AuthenticationProviderImp  

**Super模式**

启动时添加系统属性

>-Dzookeeper.DigestAuthenticationProvider.SuperDigest=super:gG7s8t3oDEtIqF6DM9LlI/R+9Ss=

***

## 序列化与协议  

zookeeper使用的是Jute序列化组件,也是最初的hadoop中的默认序列化组件(后来使用Avro),考虑到替换的复杂性以及序列化并不是zookeeper性能的瓶颈,所以一直使用的是这个古老的序列化组件.  

### 使用Jute  

1. 实体类需要实现Record接口的serialize/deserialize方法.  
2. 构建一个序列化器BinaryOutputArchive  
3. 序列化,调用实体类的serialize()方法将对象序列化到tag中去
4. 反序列化

### 深入Jute  

### 通信协议  

基于TCP/IP协议

| len | 请求头 | 请求体 |
| - |- | - |
| len  | 响应头 | 响应体|

获取节点的完整请求  
| Bit Offset|0-3|4-7|8-11|12-15|16-(n-1)|n|
|-|-|-|-|-|-|-|
|protocol|len|xid|type|len|path|watch|

**请求头:RequestHeader**

包含xid和type  
xid记录客户端请求发起的先后序号,用来确保单个客户端请求的响应顺序  
type代表请求的操作类型,常见的操作类型

* 创建节点 OpCode.create:1
* 删除节点 OpCode.   :2

...

**请求体:Request**


获取节点的响应  
|Bit Offset|0-3|4-7|8-15|16-19|20-23|len位|48位|8位|
|-|-|-|-|-|-|-|-|-|
|Protocol|len|xid|zxid|err|len|data|...|pzxid|

...↓

|8位|8位|8位|8位|4位|4位|4位|8位|4位|4位|
|-|-|-|-|-|-|-|-|-|-|
|czxid|mzxid|ctime|mtime|version|cversion|aversion|ephemeral owner|dataLength|numChildren|

***

## 客户端  

核心组件  

* Zookeeper实例 客户端的入口
* ClientWatchManager 客户端Watcher管理器
* HostProvide 客户端地址列表管理器
* ClientCnxn 客户端核心线程  


### 一次会话的创建过程

**初始化阶段**  

1. 初始化zookeeper对象  
2. 设置会话默认Watcher
3. 构造zookeeper服务器地址列表管理器HostProvider
4. 创建并初始化客户端网络连接器ClientCnxn
5. 初始化SendThread和EventThread  

**会话创建阶段**  

6. 启动SendThread和EventThread  
7. 获取一个服务器地址
8. 创建TCP连接  
9. 构造ConnectRequest请求
10. 发送请求  

**响应处理阶段**  

11. 接收服务端响应  
12. 处理Response  
13. 连接成功  
14. 生成事件 SyncConnect-None  
15. 查询Watcher
16. 处理事件  

### 服务器地址列表  

通常配置为
>192.168.1.100:2181,192.168.1.101:2181,192.168.1.102:2181  

**Chroot**  
客户端隔离命名空间  

客户端设置了chroot后,客户端对服务器的所有操作都将限制在自己的命名空间下
>192.168.1.100:2181,192.168.1.101:2181,192.168.1.102:2181/apps/x  

**解析服务器地址**  
StaticHostProvider使用Collections工具类的shuffle方法将服务器地址列表进行随机打散  
之后通过调用next()方法获取一个可用的服务器地址,next()获取的数据是一个循环环形数据,所以随机过程是一次性的,之后获取的顺序是固定的.  

### ClientCnxn 网络I/O  

**Packet**  


***

## 会话

### 会话创建  

**Session**

* sessionID 会话ID  
* TimeOut 会话超时时间  
* TickTime 下次会话超时时间点  
* isClosing 标识一个会话是否已经被关闭

**sessionID**  

```java
    public static long initializeNextSession(long id){
        long nextSid = 0;
        nextSid = (System.currentTimeMillis() << 24) >> 8;
        nextSid = nextSid | (id <<56);
        return nextSid;
    }
```

这TM才叫算法流程

1. 获取当前时间的毫秒表示  
2. 左移24位   3.4.6之前的版本有个bug 2022年会出问题....
3. 右移8位  
4. 添加机器标识SID  (myid文件内容)
5. 将3,4操作得到的64位的数值进行 | 操作

### 会话管理

**分桶策略**  

***

## 服务器启动  

### 单机版服务端启动  

大致可以分为五个主要步骤

* 配置文件解析  
* 初始化数据管理器
* 初始化网络I/O管理器
* 数据恢复
* 对外服务  

**预启动**  

1. 统一由QuorumPeerMain作为启动类  
2. 解析配置文件zoo.cfg  
3. 创建并启动历史文件清理器 DatadirCleanupManager  
4. 判断当前是集群模式还是单机模式的启动  
5. 再次进行配置文件zoo.cfg的解析  
6. 创建服务器实例ZooKeeperServer

**初始化**  

1. 创建服务器统计器 ServerStats  
2. 创建ZooKeeper数据管理器FileTxnSnapLog
3. 设置服务器tickTime和会话超时时间限制  
4. 创建ServerCnxnFactory
5. 初始化ServerCnxnFactory
6. 启动ServerCnxnFactory主线程
7. 恢复本地数据
8. 创建并启动会话管理器
9. 初始化zookeeper的请求处理链
10. 注册JMX服务
11. 注册zookeeper服务器实例  

### 集群版服务端启动

**预启动**  

1. 统一由QuorumPeerMain作为启动类  
2. 解析配置文件zoo.cfg  
3. 创建并启动历史文件清理器 DatadirCleanupManager  
4. 判断当前是集群模式还是单机模式的启动  

**初始化**  

1. 创建ServerCnxnFactory
2. 初始化ServerCnxnFactory
3. 创建ZooKeeper数据管理器FileTxnSnapLog
4. 创建QuorumPeer实例
5. 创建内存数据库ZKDatabase
6. 初始化QuorumPeer
7. 恢复本地数据
8. 启动ServerCnxnFactory主线程

**Leader选举**  

1. 初始化Leader选举
2. 注册JMX服务
3. 检测当前服务器状态
4. leader选举

**Leader和Follower启动期交互过程**  

1. 创建leader和follower服务器
2. leader服务器启动follower接收器LearnerCnxAcceptor  
3. leader服务器开始和leader建立连接  
4. leader服务器创建LearnerHandler
5. 向leader注册
6. leader解析Learner信息,计算新的epoch
7. 发送leader状态
8. learner发送ACK消息
9. 数据同步
10. 启动leader和learner服务器

**leader和follower启动**  

1. 创建并启动会话管理器
2. 初始化zookeeper的请求处理链
3. 注册JMX服务.  

*** 

## Leader选举

### leader选举算法分析

zookeeper中提供了3中选举算法,可以通过zoo.cfg配置文件中使用
>electionAlg=1~3
3.4.0之后废弃了0,1,2...
使用的是FastLeaderElection选举算法  





