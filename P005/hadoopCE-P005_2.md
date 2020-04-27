---

title: "大数据集群搭建005-P005_1zookeeper深入学习"
scp: 2020/4/26 7:35:40
tags: hadoop,zookeeper

---

# zookeeper  

## zookeeper是什么  

zookeeper是一个开发源码的分布式协调服务.  
zookeeper是一个典型的分布式数据一致性解决方案,分布式应用程序可以基于它实现如数据发布/订阅,负载均衡,命名服务,分布式协调通知,集群管理,Master选举,
分布式锁,和分布式队列功能.  

## zookeeper可以保证如下分布式一致性特性  

### 顺序一致性  

从同一个客户端发起的事务请求,最终会严格地按照其发起顺序被应用到zookeeper中  

### 原子性  

所有事务请求的处理结果在整个集群上的应用情况是一致的,要么整个集群都成功,要么整个集群都不成功.  

### 单一视图  

无论客户端连接的是哪个zookeeper服务器,其看到的服务端的数据模型都是一致的.  

### 可靠性  

一旦服务端成功的应用了一个事务,并完成对客户端的响应,那么由该事务所引起的服务端状态变化将会一直保留下来,除非有另一个事务对其进行了变更.  

### 实时性

zookeeper保证在一定时间段内,客户端最终一定能够从服务端读取到最新的数据状态.  

## zookeeper的设计目标  

### 1.简单的数据模型  

树形命名空间  

### 2.可以构建集群  

### 3.顺序访问  

客户端的请求会分配一个全局唯一的递增序列  

### 4.高性能

数据存储在内存中

## zookeeper基本概念  

### 集群角色  

zookeeper不同于一般的集群Master/Slave(主备模式),而是引用了Leader,Follower,Observer三种角色,
Zookeeper集群中的所有机器通过一个Leader选举过程来选定一台被称为"Leader"的集群,Leader服务器为客户端提供读和写服务,
除Leader外其他机器包括Follower和Observer都能提供读服务.区别在于Observer不参与选举过程,也不参与写操作的过半写成功策略.  

### 会话

Session指客户端会话.

### 数据节点 (Znode)  

Zookeeper中的节点分为两类:第一类是指常见的集群中的机器,可以称之为机器节点;第二类指数据模型中的数据单元,我们称之为数据节点-ZNode.
zookeeper将所有数据存储在内存中,数据模型就是一颗树,由斜杠/分割的路径就是一个Znode.每个Znode上都会保存自己的数据内容,同时还会保留一系列属性信息.
数据节点又分为持久节点和临时节点.  

### 版本

zookeeper的每个Znode都会存储数据,对于每个Znode,zookeeper都会为其维护一个叫Stat的数据结构,Stat中记录了这个Znode的三个数据版本,分别是version(当前Znode版本),
cversion(当前Znode子节点版本)和aversion(当前Znode的ACL版本).  

### Watcher 事件监听器  

Zookeeper允许用户在指定节点上注册一些Watcher,并且在一些特定事件触发的时候,zookeeper会将事件通知到感兴趣的客户端上.  

### ACL  

zookeeper采用ACL(Access Control Lists)策略来进行权限控制,类似unix系统的权限控制,包括:

* CREATE  
* READ  
* WRITER  
* DELETE  
* ADMIN  

## ZAB(Zookeeper Atomic Broadcast)协议,zookeeper原子消息广播协议  

所有事务的请求必须由一个全局唯一的服务器来协调处理,这样的服务器被称为Leader服务器,
而余下的其他服务器则称为follower服务器.Leader服务器负责将一个客户端请求装换成一个事务Proposal(提取),
并将该proposal分发给集群中的其他所有follower服务器.之后leader服务器需要等待所有的folloer服务器反馈,
一旦超过半数的follower服务器进行了正确的反馈后那么Leader就会再次向所有的follower服务器分发commit消息,要求其将前一个proposal进行提交.  

ZAB主要有三个阶段:

* 发现  
* 同步  
* 广播  

## zookeeper使用  

