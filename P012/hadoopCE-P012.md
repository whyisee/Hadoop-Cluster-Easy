---

title: "大数据集群搭建012-hbase/hive开发环境"
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

## hive开发环境

不知道是不是因为远程机随便关机的原因,突然发现hive无法使用了,还一直找不到原因,大概就是元数据有问题,没办法删了mysql中的hive库重新初始化了一下又ok了.这里先忽略.  
java连hive依赖的jar包也不多,但是貌似hive版本高了之后的jar包会有其他的依赖,这里先使用一个低版本的jdbc包

```xml
        <dependency>
            <groupId>org.apache.hive</groupId>
            <artifactId>hive-jdbc</artifactId>
            <version>2.3.5</version>
        </dependency>

```

java程序  
```java
package com.bigdata.hive;

import java.sql.*;

public class HiveTest {
    private static String driverName =
            "org.apache.hive.jdbc.HiveDriver";
    public static void main(String[] args)
            throws SQLException {
        try {
            Class.forName(driverName);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.exit(1);
        }
        Connection con = DriverManager.getConnection(
                "jdbc:hive2://hadoop01:10000", "td1", "hive");
        Statement stmt = con.createStatement();
        String tableName = " td1.tb1 ";
        String sql = "select * from td1.tb1 ";
        ResultSet res = stmt.executeQuery(sql);

        sql = "select * from " + tableName;
        res = stmt.executeQuery(sql);
        while (res.next()) {
            System.out.println(String.valueOf(res.getInt(1)) + "\t"
                    + res.getString(1));
        }
    }


}

```

### 问题

>Required field 'serverProtocolVersion' is unset!  

网上有人说是core-site.xml里面修改组啥的,试了半天没啥用,终于看到有人说是hiveserver2和hive的版本不同的原因,于是还是换回高版本的驱动jar包,但是依赖冲突又不会解决,于是就一个版本一个版本的降级,最后找到2.8.5这个版本可以使用.也不报这个错了