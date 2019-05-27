---

title: "大数据集群搭建008-hbase,hive整合"
scp: 2019/5/23 7:35:40
tags: hbase,hive

---

# Hive与Hbase的整合
hive和hbase的安装,请参照之前的文章.  
# hive配置修改
### hive-site.xml
```xml
<property>
    <name>hbase.zookeeper.quorum</name>
    <value>hadoop01:2181,hadoop02:2181,hadoop03:2181</value>
</property>
```
### hive-env.sh
```sh
# 添加一个环境变量
export HIVE_CLASSPATH=$HIVE_CLASSPATH:/hadoop/hbase/lib/*
```

# 验证
### hbase 建表
```hbase
create 't1',{NAME => 'f1', VERSIONS => 2},{NAME => 'f2', VERSIONS => 2}
```
### hive建表关联Hbase
```hive
CREATE  TABLE t1_hive (
rowkey string,
f1 STRING,
f2 STRING
) STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,info:f1,info:f2")
TBLPROPERTIES ("hbase.table.name" = "t3");
```
1. 创建完可在hbase中查看,hbase中put设置值后,可通过hive查看  
![hbase效果](http://ww1.sinaimg.cn/large/0066tqialy1g3gbs13fsyj30d604a0sp.jpg)  
![hive效果](http://ww1.sinaimg.cn/large/0066tqialy1g3gbt9onxsj30e906bdg3.jpg)

2. hive中插入值后,可在hbase中查看

# 问题
> Got error, status message , ack with firstBadLink   
hadoop datanode节点的防护墙未关闭  
永久关闭防火墙 执行下面两条命令   
```bash
sudo service iptables stop 
sudo chkconfig iptables off 
```

>hive建完表就退出了,和hbase同时运行就退出等莫名其妙的问题  
虚拟机内存不足....

>Could not find uri with key [dfs.encryption.key.provider.uri]  
未找到影响,未解决


# 集群启动顺序
```bash
# 1.hadoop
stat-all.sh
# 2.mysql
sudo service mysqld restart
# 3.zookeeper
start-zook.sh
# 4.hbase
start-hbase.sh
#
```