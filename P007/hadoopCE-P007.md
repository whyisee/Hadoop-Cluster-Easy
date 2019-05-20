---

title: "大数据集群搭建007-hadoop基础"
scp: 2019/5/20 22:35:40
tags: hadoop

---

## hadoop文件系统

### hdfs 的概念

#### 数据块  
每个磁盘都有默认的数据块大学,这是磁盘进行数据读写的最小单位  
hdfs也有快的概念,默认为128MB  
hdfs中的fsck指令可以显示块信息  
>hdfs fsck / -files -blocks  
#### namenode和datanode  
namenode是管理节点.管理文件系统的命名空间.维护着文件系统树及整颗树内所有的文件和目录.这些信息以两个文件的形式永久保存在本地磁盘上:命名空间镜像文件和编辑日志文件.  
datanode是文件系统的工作节点.他们根据需要存储并检索数据块,并定期向namenode发送他们所存储的块列表  

#### 块缓存

#### 联邦hdfs  

#### hdfs的高可用性

### 命令行接口

>hadoop fs -copyFromLocal 

### hadoop文件系统  
hadoop有一个抽象的文件系统概念,hdfs只是其中一个实现,

### hadoop java接口

#### 1.URL接口方式

```java
import org.apache.zookeeper.common.IOUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import org.apache.hadoop.fs.FsUrlStreamHandlerFactory;

public class HadoopInterfaceTest {
    public static void main(String args[]) {
        System.setProperty("hadoop.home.dir", "D:\\software\\hadoop-2.8.5\\");
        URL.setURLStreamHandlerFactory(new FsUrlStreamHandlerFactory());
        InputStream in = null;
        try {
            in = new URL("hdfs://hadoop01:9000/tmp/test1.txt").openStream();
            //读取文件
            BufferedReader reader = new BufferedReader(new InputStreamReader(in));
            String line = null;
            while((line =reader.readLine())!= null){
                System.out.println(line.toString());
            }

        } catch (IOException e) {
            e.printStackTrace();
            IOUtils.closeStream(in);
        }

    }
}


```
#### 遇到的问题:  
1.windows环境下开发,先安装hadoo客户端  
2.下载winutils.exe放到$HADOOP_HOME/bin下  
3.URL.setURLStreamHandlerFactory(new FsUrlStreamHandlerFactory());  
4.System.setProperty("hadoop.home.dir", "D:\\software\\hadoop-2.8.5\\");  
5.引入对应版本的jar包,主要有hadoop-hdfs-client,hadoop-client,hadoop-common  
6.集群主机的防火墙记得关闭  

