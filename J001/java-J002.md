---

title: "Java系统学习016-源码阅读计划"
scp: 2020/2/6 23:35:40
tags: java,JVM  

---

# 主要内容  

1. IO相关的包  
2. NIO相关的包  
3. 集合相关的包  
4. 多线程相关的包  
5. JVM GC等  
6. 泛型/反射  
7. 注解  

---

## IO相关的包  

### 字节流-InputStream  

**源码阅读**  

1.实现了Closeable接口的一个抽象类  
2.静态常量最大跳过缓存区大小 MAX_SKIP_BUFFER_SIZE = 2048  
3.必须实现的抽象方法read() 返回int 类型,-1表示流结束.