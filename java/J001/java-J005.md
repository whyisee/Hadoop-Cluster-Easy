---

title: "Java系统学习018-数据结构相关-链表(一)"
scp: 2020/2/19 23:35:40
tags: java,LinkedList  

---


## 链表-java链表LinkedList源码阅读

链表属于一个很常见的数据结构,但是一些基本操作还是不太熟悉,自己写的链表代码总感觉不太对.  
在阅读hadoop源码时发现,hadoop在处理命令选项和参数时,是将数据保存到LinkedList链表中使用,这就更需要尽快将链表特性弄清楚.  

## 文档介绍-手工翻译工地英语  

双向链表(LinkedList),实现了List和Deque接口,实现了所有的可选择的操作,允许保存任意元素,包括null.  

所有的操作的执行都符合双链表的预期.按索引操作链表将会从头或者尾开始遍历,取决于哪一个更接近索引.  

记住这个实现不是 synchronized 同步的,如果有多个线程同时访问一个链表,有多于一个线程修改链表的结构,一定需要从外部同步.(结构改变的操作有新增删除节点,add/delete,只是改变节点数据值不会改变链表的结构) 这通常需要在一些对象上synchronized 同步,来自然的封装链表.  

如果没有这样的对象,这个链表需要被 wrapped 使用 Collections.synchronizedList()方法,为防止不同步产生事故,这是在创建时最好的做法.
> List list = Collections.synchronizedList(new LinkedList(...));

