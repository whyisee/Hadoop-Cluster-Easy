---

title: "大数据集群搭建012-hbase开发环境"
scp: 2019/7/19 7:35:40
tags: hadoop,hbase

---

近期需要重做公司的某个项目,将该项目中的所有查询改为hbase操作,由于之前都是复制粘贴修改的代码,此次正好借着机会,学习下hbase的基础.  
首先遇到的问题就是搭建开发环境,这个环境其实用之前的项目就可以,但是原来的项目框架太老,而且是个web项目,调试起来十分不方便,于是就  
自己重新创建一个小的工程用来测试和学习使用.

## 使用jar包
原来项目是直接引入的jar包非常乱,而实际上hbase测试只用到一个包
```xml
        <dependency>
            <groupId>org.apache.hbase</groupId>
            <artifactId>hbase-client</artifactId>
            <version>2.2.0</version>
        </dependency>
```

## 代码


```java
package com.bigdata.hbase;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.util.Bytes;
import java.io.IOException;
public class HbaseTest {
    public static void main(String [] args) throws IOException {
    Configuration configuration = HBaseConfiguration.create();
    configuration.addResource("conf/hbase-site.xml");

        Connection conn= ConnectionFactory.createConnection(configuration);
        Table table = null;
            table = conn.getTable( TableName.valueOf("t1"));

        Get get = new Get(Bytes.toBytes("2"));
        get.addColumn(Bytes.toBytes("f1"),Bytes.toBytes("c1"));
        Result result = table.get(get);
        byte[] val = result.getValue(Bytes.toBytes("f1"),Bytes.toBytes("c1"));
        System.out.println(Bytes.toString(val));
    }
}
```