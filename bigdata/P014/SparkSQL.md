---

title: "大数据集群搭建-SparkSQL"
scp: 2020/1/26 7:35:40
tags: SparkSQL

---


1.1． Spark SQL的前世今生

    Shark是一个为Spark设计的大规模数据仓库系统，它与Hive兼容。Shark建立在Hive的代码基础上，并通过将Hive的部分物理执行计划交换出来。这个方法使得Shark的用户可以加速Hive的查询，但是Shark继承了Hive的大且复杂的代码使得Shark很难优化和维护，同时Shark依赖于Spark的版本。随着我们遇到了性能优化的上限，以及集成SQL的一些复杂的分析功能，我们发现Hive的MapReduce设计的框架限制了Shark的发展。在2014年7月1日的Spark Summit上，Databricks宣布终止对Shark的开发，将重点放到Spark SQL上。

1.2． 什么是Spark SQL

Spark SQL是Spark用来处理结构化数据的一个模块，它提供了一个编程抽象叫做DataFrame并且作为分布式SQL查询引擎的作用。

相比于Spark RDD API，Spark SQL包含了对结构化数据和在其上运算的更多信息，Spark SQL使用这些信息进行了额外的优化，使对结构化数据的操作更加高效和方便。

有多种方式去使用Spark SQL，包括SQL、DataFrames API和Datasets API。但无论是哪种API或者是编程语言，它们都是基于同样的执行引擎，因此你可以在不同的API之间随意切换，它们各有各的特点，看你喜欢那种风格。

1.3． 为什么要学习Spark SQL 

我们已经学习了Hive，它是将Hive SQL转换成MapReduce然后提交到集群中去执行，大大简化了编写MapReduce程序的复杂性，由于MapReduce这种计算模型执行效率比较慢，所以Spark SQL应运而生，它是将Spark SQL转换成RDD，然后提交到集群中去运行，执行效率非常快！

1.易整合
将sql查询与spark程序无缝混合，可以使用java、scala、python、R等语言的API操作。

2.统一的数据访问
以相同的方式连接到任何数据源。

3.兼容Hive
支持hiveSQL的语法。

4.标准的数据连接
可以使用行业标准的JDBC或ODBC连接。

2． DataFrame

2.1． 什么是DataFrame

DataFrame的前身是SchemaRDD，从Spark 1.3.0开始SchemaRDD更名为DataFrame。与SchemaRDD的主要区别是：DataFrame不再直接继承自RDD，而是自己实现了RDD的绝大多数功能。你仍旧可以在DataFrame上调用rdd方法将其转换为一个RDD。

在Spark中，DataFrame是一种以RDD为基础的分布式数据集，类似于传统数据库的二维表格，DataFrame带有Schema元信息，即DataFrame所表示的二维表数据集的每一列都带有名称和类型，但底层做了更多的优化。DataFrame可以从很多数据源构建，比如：已经存在的RDD、结构化文件、外部数据库、Hive表。

2.2． DataFrame与RDD的区别

RDD可看作是分布式的对象的集合，Spark并不知道对象的详细模式信息，DataFrame可看作是分布式的Row对象的集合，其提供了由列组成的详细模式信息，使得Spark SQL可以进行某些形式的执行优化。DataFrame和普通的RDD的逻辑框架区别如下所示：



