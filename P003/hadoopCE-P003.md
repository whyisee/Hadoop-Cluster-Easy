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

### ssh配置
