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
 增加程序启动日志,和添加钩子终止时记录日志  
    - LOG.info(createStartupShutdownMessage(classname, hostname, args));  
    - SystemUtils.IS_OS_UNIX 判断是否为类unix系统
    - SignalLogger.INSTANCE.register(LOG); 注册接受linux系统的中断信号  
     registered UNIX signal handlers for [TERM, HUP, INT]  
    - ShutdownHookManager.get().addShutdownHook() 增加终止hook,终止时打印终止日志  

 - Configuration conf = new YarnConfiguration();  
   - 初始化静态常量  
   ... 太多
   - 执行静态代码  
      - addDeprecatedKeys();  
      添加不推荐使用的配置,添加时先保存为旧的配置,然后更新到新的上
      - Configuration.addDefaultResource(YARN_DEFAULT_CONFIGURATION_FILE);  
      yarn-default.xml
      - Configuration.addDefaultResource(YARN_SITE_CONFIGURATION_FILE);  
      yarn-site.xml
      - Configuration.addDefaultResource(RESOURCE_TYPES_CONFIGURATION_FILE);  
      resource-types.xml
      - 父类的静态代码  
      addDefaultResource("core-default.xml");  
      addDefaultResource("core-site.xml");  
      addDefaultResource("hadoop-site.xml");  

   - 执行构造函数  
   执行父类Configuration的构造函数  
   
- GenericOptionsParser hParser = new GenericOptionsParser(conf, argv);


