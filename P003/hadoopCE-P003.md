---

title: "大数据集群搭建003-P003集群安装"
scp: 2019/4/12 7:35:40
tags: hadoop,hdfs

---


## P003集群安装

### 基础步骤
- 安装java  
- 创建linux用户
- 安装hadoop
- ssh配置
- 配置hadoop  
- 格式化HDFS文件系统  
- 启动和停止守护进程
- 创建目录

### 安装hadoop

1. [官网](hadoop.apache.org)下载hadoop发布包,例如
>curl -O  www-us.apache.org/dist/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz
2. 一般安装到/usr/local 或者/opt下
3. 解压 
>tar -xzf hadoop-x.y.z.tar.gz
4. 修改 hadoop目录的属主和属组
>sudo chown -R hadoop:hadoop hadoop-x.y.z
5. 配置环境变量,一般是配置位置 :~/.bash_profile
>export HADOOP_HOME=/usr/local/hadoop-x.y.z  
>export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin


先记录下手工执行的命令,后期再整理下
>sudo tar -xzf hadoop-3.2.0.tar.gz -C /opt/  
sudo chown hadoop:hadoop -R /opt/hadoop-3.2.0/  
echo "#hadoop配置" >> ~/.bash_profile  
echo "export HADOOP_HOME=/opt/hadoop-3.2.0/" >> ~/.bash_profile  
echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> ~/.bash_profile  
. ~/.bash_profile   
scp hadoop-3.2.0.tar.gz hadoop@red02:~/
### ssh配置

#### ssh-agent需要再研究

### 配置hadoop

#### 目录配置

>sudo mkdir -p /data01/hadoop/data /data01/hadoop/name /data01/hadoop/tmp
chown hadoop:hadoop -R /data01/hadoop/
#### 配置core-site.xml
```bash
vi $HADOOP_HOME/etc/hadoop/core-site.xml 

<configuration>
  <property>
    <name>hadoop.tmp.dir</name>
    <value>file:/data01/hadoop/tmp</value>
    <description>A base for other temporary directories.</description>
  </property>
  <property>
    <name>fs.default.name</name>
    <value>hdfs://hadoop01:9000</value>
  </property>
</configuration>
```
#### 配置hdfs-site.xml 
```bash
vi $HADOOP_HOME/etc/hadoop/hdfs-site.xml 

<configuration>
  <property>
    <name>dfs.replication</name>
    <value>2</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:/data01/hadoop/name</value>
    <final>true</final>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:/data01/hadoop/data</value>
    <final>true</final>
  </property>
  <property>
    <name>dfs.namenode.secondary.http-address</name>
    <value>hadoop01:9001</value>
  </property>
  <property>
    <name>dfs.webhdfs.enabled</name>
    <value>true</value>
  </property>
  <property>
    <name>dfs.permissions</name>
    <value>false</value>
  </property>
</configuration>
```
#### 配置yarn-site.xml
```bash
vi $HADOOP_HOME/etc/hadoop/yarn-site.xml

<configuration>

  <!-- Site specific YARN configuration properties -->
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>hadoop01</value>
  </property>
</configuration>
```
#### 配置mapred-site.xml
```bash
vi $HADOOP_HOME/etc/hadoop/mapred-site.xml 

<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
```
#### 配置salve

```bash
vi $HADOOP_HOME/etc/hadoop/slaves 

hadoop01
hadoop02
hadoop03
```

### 复制hadoop到其他主机


### 格式化HDFS文件系统
>hdfs namenode -format

### 启动和停止守护进程
>start-dfs.sh

### 启动yarn守护进程
>start-yarn.sh  

### 运行测试 
>hadoop jar /opt/hadoop-2.8.5/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.5.jar pi 5 10  


### 问题汇总

告警提示:java.net.NoRouteToHostException: No route to host  
网络问题,暂时关闭防火墙处理
```bash
service iptables stop #临时
chkconfig iptables off  #永久
```
告警提示:JAVA_HOME is not set and could not be found  
解决方法:添加环境变量  
>vi $HADOOP_HOME/etc/hadoop/hadoop-env.sh  
#将export JAVA_HOME=${JAVA_HOME}改为  
export JAVA_HOME=/usr/java/jdk1.8.0_45


告警提示:You have loaded library /opt/hadoop-3.2.0/lib/native/lib  
处理:  
export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_PREFIX}/lib/native   
export HADOOP_OPTS="-Djava.library.path=$HADOOP_PREFIX/lib" 

告警提示:Unable to load native-hadoop library for your platform  
处理:  
未处理  
### hadoop配置

#### 配置管理
ambari

#### 环境配置

1. java   
    1.在hadoop-env.sh中配置 JAVA_HOME  
    2.在shell中设置