---

title: "大数据集群搭建官网文档阅读"
scp: 2020/1/26 7:35:40
tags: hadoop

---

## 阅读纯英文文档具有一定的挑战性  

安装联系的hadoop版本是2.8.5版本，找到对应版本的文档。  

文档右边的结构树大致分为12部分

重要的包括：

- general 概述
- common 通用
- HDFS  
- MapReduce
- yarn
- tools
- configuration  

### General  

里面内容有环境要求，下载，安装，启动步骤，基础配置，fs shell介绍等。  
前面的安装配置的内容不再重复，重点记录下fs命令。  

**fs**

>hadoop fs  <args>  

appendToFile  追加文件到hdfs上文件，可同时追加多个文件  

cat 同linux cat  
checksum 同linux 获取md5值  
chgrp 改变文件属组group  
chmod 改变文件权限  
chown 改变文件属主  

copyFromLocal 类似put 但是源文件只能是本地文件  
    -p 保存文件元数据信息，属主，权限  
    -f 覆盖已存在文件  
    -l 不懂  
    -d 不创建临时文件  

copyToLocal 类似get  

count  
cp  
createSnapshot  创建快照  
deleteSnapshot  删除快照  
df  -h  
du  -h  
dus = du -s  
expunge  删除回收站的文件，建立新的检测点  
find  
get  下载  
    -p 保持元数据，属主，权限信息  
    -f  
    -ignorecrc  
    -crc  

getfacl  展示ACL信息，属主，权限信息 -R 展示目录下所有  
getfattr  不懂  
getmerge  hdfs文件合并 ,可知道目录，或多个文件，指定结果目录  
help  
ls  
lsr = ls -R  
mkdir  
moveFromLocal  类似put  
mveToLocal  不再支持。。。  
mv  
put  
renameSnapshot  
rm  
rmdir  
rmr =rm -r  
setfacl  
setfattr  
setrep  
stat  显示文件状态  
tail  
text  
test  
touchz  创建一个空文件  
truncate  清空目录，-w 可以知道文件权限模式  
usage  

**兼容性**  

Java API

这部分的内容已经大部分看不懂了。先看感兴趣的重点HDFS  

## HDFS  

