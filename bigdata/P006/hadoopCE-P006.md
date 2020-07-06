---

title: "大数据集群搭建006-P006hive安装"
scp: 2019/4/17 22:35:40
tags: hadoop,hive

---

## hive安装

### mysql安装

使用yum安装
```bash
yum install mysql
yum install mysql-server
```

### 下载
### 解压
### 配置环境变量
### 工具脚本安装

[下载地址](https://github.com/whyisee/Hadoop-Cluster-Easy/releases/download/P003/remote_install_software.sh)

### hadoop目录创建
```bash
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /user/hive/tmp
hdfs dfs -mkdir -p /user/hive/log
hdfs dfs -chmod g+w /user/hive/warehouse
hdfs dfs -chmod g+w /user/hive/tmp
hdfs dfs -chmod g+w /user/hive/log
```

### mysql用户创建
```mysql
CREATE DATABASE hive; 
USE hive; 
CREATE USER 'hive'@'localhost' IDENTIFIED BY 'hive';
set password for hive@'localhost'= password('hive');
GRANT ALL ON hive.* TO 'hive'@'localhost' IDENTIFIED BY 'hive'; 
GRANT ALL ON hive.* TO 'hive'@'%' IDENTIFIED BY 'hive'; 
GRANT ALL ON hive.* TO 'hive'@'hadoop01' IDENTIFIED BY 'hive'; 
FLUSH PRIVILEGES; 
quit;
```


### hive 配置文件
hive-env.sh
```shell
export JAVA_HOME=/opt/jdk1.8.0_211/
export HADOOP_HOME=/opt/hadoop-2.8.5/
export HIVE_HOME=/opt/apache-hive-3.1.1-bin/
export HIVE_CONF_DIR=$HIVE_HOME/conf
export HIVE_AUX_JARS_PATH=$HIVE_HOME/lib/*
```
hive-site.xml
```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
   <property>
    <name>hive.exec.scratchdir</name>
    <value>/user/hive/tmp</value>
    <description></description>
  </property>
  <property>
    <name>hive.metastore.warehouse.dir</name>
    <value>/user/hive/warehouse</value>
    <description>location of default database for the warehouse</description>
  </property>
<property>
    <name>hive.querylog.location</name>
    <value>/user/hive/log</value>
    <description>Location of Hive run time structured log file</description>
  </property>
 <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:mysql://192.168.56.201:3306/hive?createDatabaseIfNotExist=true</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>com.mysql.jdbc.Driver</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>hive</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>hive</value>
  </property>
</configuration>

```

### 初始化
>schematool -dbType mysql -initSchema

### 问题汇总
#### jdbc驱动
需手动下载,放到$HIVE_HOME/lib 
#### hive启动 Name node is in safe mode.
手工恢复命令
>hadoop dfsadmin -safemode leave 