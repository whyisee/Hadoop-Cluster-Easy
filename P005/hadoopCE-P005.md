---

title: "大数据集群搭建005-P005zookeeper"
scp: 2019/4/15 7:35:40
tags: hadoop,zookeeper

---

## zookeeper 特点

- zookeeper是简单的 zookeeper的核心是一个精简的文件系统,提供一些简单的操作和额外的抽象操作,如排序和通知  
- zookeeper是富有表现力的 zookeeper的基本操作是一组丰富的构件,可用于实现多种协调数据结构和协议,如分布式队列,分布式所和一组节点中的领导者选举  
- zookeeper具有高可用性 ,可以帮系统避免出现单点故障  
- zookeeper采用松耦合交互方式  
- zookeeper是一个资源库

## 安装和运行

下载

解压  

安装  

配置环境变量

考虑脚本实现

配置文件:zoo.cfg
>tickTime=2000  
dataDir=/data01/zookeeper  
clientPort=2181


启动
>zkServer.sh start

命令使用
>echo ruok |nc localhost 2181  
telnet


![zookeeper命令](http://ww1.sinaimg.cn/large/0066tqialy1g25aywbtcwj30kf0jlqar.jpg)