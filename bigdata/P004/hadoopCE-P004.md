---

title: "大数据集群搭建004-P004yarn工作机制"
scp: 2019/4/15 7:35:40
tags: hadoop,yarn

---


## Yarn的基本架构

### 核心服务

- 资源管理器:管理集群上的资源resource

- 节点管理器:管理集群上的容器container


### 工作流程

![工作流程](http://ww1.sinaimg.cn/large/0066tqialy1g23qyh5waej30j20gg43j.jpg) 

1. 创建应用
2. 联系资源管理器,运行一个application master进程
3. 资源管理器找到一个能在容器中运行application master的节点管理器node manager
4. 1有可能在所处的容器中直接运行,最后将结果返回客户端
5. 2有可能向资源管理器请求更多的容器


大多数yarn应用使用专属于各应用的远程通信机制来向客户端传递状态和返回结果.

### 资源请求

yarn可以指定每个请求的容器需要的计算机资源(内存和CPU),还可以指定对容器的本地限制要求.

yarn应用可以在运行的任意时刻提出资源申请  

### 应用生命期

按照应用到用户运行的作业直接的映射关系分类:

-   一个用户作业对应一个应用  mapreduce采用的方式
-   作业的每个工作流或者每个用户的对话对应一个应用 spark采用这种模型
-   多个用户共享一个长期运行的应用.

### 构建yarn应用

apache slider  
apache Twill        
distributed shell

## yarn与MapReduce1相比

好处:
-   可扩展性
-   可用性
-   利用率
-   多租户

## yarn中的调度

### 调度选项
1. FIFO调度器
2. 容器调度器
3. 公平调度器

### 容器调度器配置
弹性队列:允许超过队列容量  
配置  
>文件名: capacity-schedule.xml  

队列放置  

>set mapreduce.queuename=  

### 公平调度器配置

1. 启用公平调度器
> 将yarn-site.xml中的yarn.resourcemanager.scheduler.class设置为ora.apache.hadoop.yarn.server.resourcemanager.schedule.fair.FairSchedule.

2. 队列配置  
>文件名:fair-scheduler.xml



## 需配合实际集群练习


