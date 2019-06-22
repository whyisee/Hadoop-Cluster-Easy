---

title: "大数据集群搭建010-spark安装,整合hive"
scp: 2019/5/21 20:35:40
tags: hadoop,spark,hive

---

### 依赖scala
需安装scala,安装scala比较简单,这里不作说明
### 下载
### 解压
### 配置SPARK_HOME
### 修改spark配置
在$SPARK_HOME/conf下copy temp文件
### `spark-env.sh`
```bash
export JAVA_HOME=/opt/jdk1.8.0_211/
export HADOOP_HOME=/opt/hadoop-2.8.5/
export SCALA_HOME=/opt/scala-2.13.0/
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HIVE_HOME=/opt/apache-hive-3.1.1-bin/

#整合hive需要
export HIVE_CONF_DIR=$HIVE_HOME/conf
export SPARK_CLASSPATH=$HIVE_HOME/lib:$SPARK_CLASSPATH

export SPARK_MASTER_IP=hadoop01

export SPARK_WORKER_MEMORY=4g

export SPARK_WORKER_CORES=2

export SPARK_WORKER_INSTANCES=1
```
### `slaves`
```bash
#填集群主机名
hadoop01
hadoop02
hadoop03
```
### 复制到其他主机
>sudo rsync -av spark-2.4.3-bin-hadoop2.7 hadoop02:/opt/  

### 启停
由于spark的启动脚本和hadoop同名,都是start-all.sh,建议到目录下启动
>$SPARK_HOME/sbin/start-all.sh

### 使用
>spark-sql  
spark-shell

### 整合hive
1. copy hive配置到spark下
>cp $HIVE_HOME/conf/hive-site.xml $SPARK_HOME/conf/
2. 修改`spark-env.sh`  
见上面配置  

3. 可能会报连不上缺少mysql connect类 复制 hive/lib下相关jar包的到spark_classpath
>cp $HIVE_HOME/lib/*mysql* $SPARK_HOME/jars/

![查询](http://ww1.sinaimg.cn/large/0066tqialy1g49vo54e85j30gm0g53zx.jpg)

