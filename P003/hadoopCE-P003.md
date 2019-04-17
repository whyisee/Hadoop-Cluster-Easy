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


### 格式化HDFS文件系统
>hdfs namenode -format

### 启动和停止守护进程
>start-dfs.sh

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