---

title: "大数据集群搭建008-hbase安装"
scp: 2019/5/22 7:35:40
tags: hbase

---

### 下载
### 解压
### 配置HBASE_HOME
### 修改配置文件
### 复制到从节点
##  主要配置
### hbase-env.sh
```sh
export JAVA_HOME=/opt/jdk1.8.0_211/
export HBASE_HOME=/opt/hbase-2.1.4/
export HBASE_CLASSPATH=$HBASE_HOME/conf
# 此配置信息，设置由hbase自己管理zookeeper，不需要单独的zookeeper。
export HBASE_MANAGES_ZK=true
export HADOOP_HOME=/opt/hadoop-2.8.5/
#Hbase日志目录
export HBASE_LOG_DIR=/tmp/hbase/logs
```

### hbase-site.xml
```xml
<configuration>
	<property>
		<name>hbase.rootdir</name>
		<value>hdfs://hadoop01:9000/hbase</value>
	</property>
	<property>
		<name>hbase.cluster.distributed</name>
		<value>true</value>
	</property>
	<property>
		<name>hbase.master</name>
		<value>hadoop01:60000</value>
	</property>
	<property>
		<name>hbase.zookeeper.quorum</name>
		<value>hadoop01,hadoop02,hadoop03</value>
	</property>
</configuration>
```
### regionservers
```
hadoop01
hadoop02
hadoop03
```
### 启停
>start-hbase.sh  
stop-hbase.sh   

### 问题
>Caused by: java.lang.ClassNotFoundException: org.apache.htrace.SamplerBuilder  

需要将htrace-core-3.1.0-incubating.jar复制到$HBASE_HOME/lib