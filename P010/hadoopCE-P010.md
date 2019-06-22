---

title: "大数据集群搭建010-hadoop源码阅读"
scp: 2019/5/29 7:35:40
tags: hadoop

---

## 准备工作
### 下载源码,解压,导入idea  
模块太多了,不知道从何开始
### 查看hadoop的启动脚本 `start-all.sh`
其中分为三步  
1. 加载hadoop配置 `hadoop-config.sh`  
2. 启动hdfs `start-dfs.sh`  
3. 启动yarn `start-yarn.sh`

### 先看第一个吧

此刻才发现自以为还行的shell水平,居然连人家的启动脚本都看不懂  
慢慢来吧  

学到了几个命令的冷门用法  
cd -P
 sudo rsync -av scala-2.13.0 hadoop03:/opt/s