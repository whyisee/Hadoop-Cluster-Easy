---

title: "大数据集群搭建011-spark学习"
scp: 2019/5/21 20:35:40
tags: hadoop,spark

---


# spark开发学习  

## Spark程序流程  

1) 从外部数据创建出输入RDD  

2) 使用如filter()这样的转化操作对RDD进行转化,以定义新的RDD  

3) 告诉Spark对需要被重用的中间结果RDD执行persist()操作  

4) 使用行动操作(如count()和first()) 来触发一次并行计算,Spark会对计算进行优化后执行  

## 简介

### 创建RDD  

Spark提供两种创建RDD的方式:  

* 读取外部数据集  

* 在一个驱动器程序中对一个集合进行并优化  

最简单的方法把一个已有的**集合**传给SparkContext的parallelize()方法,这种方式一般是用来测试  

python

```pythone
lines = sc.parallelize(["1","2"])

```

scala

```scala
val lines = sc.parallelize(list("1","2"))
```

java

```java
JavaRDD<String> lines = sc.parallelize(Arrays.asList("1","2"))
```

更多的还是从外部存储数据中来创建RDD  
比如
>textFile("path");

### RDD操作  

#### 转化操作

转化操作返回的是新的RDD, 如
>filter()

转化操作不会改变已有的inputRDD的数据,而是放回一个新的RDD,inputRDD还可以在后面的程序中使用  

#### 行动操作  

行动操作会返回新的输出,它会强制执行那些求值必须使用到的RDD的转化操作  
>take(10)

#### 惰性求值  

spark使用惰性求值,这样就可以把一些操作合并到一起减少计算数据的步骤,在Spark中写出一个非常复杂的映射不见得能比用很多简单的连续操作获得好很多的性能,因此,用户可以用更小的操作来组织他们的程序,这样也使得这些操作更容易管理  

#### 向Spark传递函数  

lambda表达式卡住

### 常见的转化操作和行动操作  

#### 基本RDD  

针对各个元素的转化操作  
map() 接收一个函数,把这个函数用于RDD中的每一个元素,将函数的返回结果作为结果RDD中对应元素的值  

filter() 接收一个函数,并将RDD中满足该函数的元素放入新的RDD中返回  

flatMap() 和map()类似,不过返回的不是一个元素,而是一个返回值序列的迭代器,最终结果就是返回多个元素  

#### 伪集合操作  

去重  
RDD.distinct()  

合并去重
RDD1.union(RDD2)  

只取重复的
RDD1.intersection(RDD2)  

取只在RDD1不在RDD2中的
RDD1.subtract(RDD2)  

笛卡尔积
RDD1.cartesian(RDD2)  

#### 行动操作  

reduce() 接收一个函数作为参数,这个函数要操作两个RDD的元素类型的数据并返回一个同样类型的元素.  

fold() 和reduce()类似,  

aggregate()  

collect()  

take()  

top()  

takeSample()  

foreach()  

#### 持久化  

### 键值对操作  

都在敲代码了,难点太多

### 连接  

### 排序

## PairRDD的行动操作  

## 数据分区  

大表频繁join小表时,可以对大表进行分区partitionBy() 再调用persist()持久化  

不懂scala太难了

***

## 数据读取与保存

这章偏应用可以结合实践操作练习下  

### 文件格式  

#### 文本文件

**读取**
python
>input = sc.textFile("file:...") 

scala
>val input = sc.textFile("file:...") 

java
>JavaRDD<String> input = sc.textFile("file:...") ;

如果有多个小文件可以使用wholeTextFiles()方法,该方法会返回一个pairRDD,其中键为输入文件的文件名
>sc.wholeTextFiles()

**保存**

>result.saveAsTextFile()  

#### JSON

以文本文件读取,然后对JSON数据进行解析  

保存同样

#### 逗号分隔值与制表符分隔值  

CSV/TSV
一般第一行为属性名

#### SequenceFile

