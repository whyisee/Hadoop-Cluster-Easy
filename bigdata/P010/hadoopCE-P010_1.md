---

title: "大数据集群搭建010_1-hadoop源码阅读-resourcemanager"
scp: 2020/7/21 7:35:40
tags: hadoop

---

# resourcemanager

看这个源码之前,大致看过了hdfs,namenode,datanode的代码,看的一头雾水,回去又看了java的多线程,Timer,泛型等再接着看这个.  

先按启动顺序过一遍  
hadoop-3.2.1中的yarn的启动顺序  
3.2.1版本的hadoop脚本看着舒服多了,增加了很多通用函数  

1. [start-all.sh]
2. start-yarn.sh
3. yarn
4. hadoop-functions.sh  -- hadoop_generic_java_subcmd_handler()
5. java org.apache.hadoop.yarn.server.resourcemanager.ResourceManager

然后看java代码  
1. 继承了CompositeService类,实现了Recoverable,ResourceManagerMXBean  

2. 初始化常量  
public static final int SHUTDOWN_HOOK_PRIORITY = 30;  
public static final int EPOCH_BIT_SHIFT = 40;  
private static final Log LOG = LogFactory.getLog(ResourceManager.class);  
private static long clusterTimeStamp = System.currentTimeMillis();  
public static final String UI2_WEBAPP_NAME = "/ui2";  


3. main方法  
- Thread.setDefaultUncaughtExceptionHandler(new YarnUncaughtExceptionHandler());  
未捕捉的异常统一处理类,主要包括4个处理判断:  

  - 是否为程序发起的退出命令,log输出error级别信息  
  - 是否为Error 异常,输出fatal级别信息  
  - 是否为内存异常异常,直接输出到控制台  
  - 非Error异常,输出error级别信息  
  - 不同的判断调用不同的退出方式  
  - ExitUtil.terminate(-1); --System.exit(status);  
  - ExitUtil.halt(-1); -- Runtime.getRuntime().halt(status);
  
 - StringUtils.startupShutdownMessage(ResourceManager.class, argv, LOG);
