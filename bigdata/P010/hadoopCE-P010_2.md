---

title: "大数据集群搭建010_2-hadoop源码阅读-Configuration"
scp: 2020/7/23 7:35:40
tags: hadoop,Configuration

---

# Configuration

这个类才是最基础的,原以为这么类只是加载个配置文件,才发现其中也用了很多高级技术.  
忍不了不去仔细看一遍这个类,况且理解了这个类,以后自己的项目的配置文件处理也可以有一套高级的通用的处理方案.  
我觉得动手写一遍这个类,学习效果会更好一些,开头的注解就懵逼了.  

### 开头注解
hadoop中的注解应该就包含这两大类了,一个是指当前类的使用者范围,一个是指当前类的稳定性

这里并没有看到注解的实现逻辑,记个坑.  
@InterfaceAudience.Public 公开的  
@InterfaceAudience.LimitedPrivate 指定可访问的项目  
@InterfaceAudience.Private  不允许其他项目访问  

@InterfaceStability.Stable 稳定版  
@InterfaceStability.Evolving 正在发展阶段  
@InterfaceStability.Unstable 不稳定的

开头注解告诉大家Configuration这个类是个公共的稳定版本的类,可以放心使用.  

### 继承和实现 
Configuration实现了Iterator和Writable两个接口  
接着看是怎么实现其中的方法的,太难,稍后再找  

### Logger  
private static final Logger LOG = LoggerFactory.getLogger(Configuration.class);  
private static final Logger LOG_DEPRECATION = LoggerFactory.getLogger("org.apache.hadoop.conf.Configuration.deprecation");

这个地方用的是slf4j的Logger,slf4j并不是日志系统的实现,它只是一个标准,我们通过使用它去调用如log4j这样的日志框架  
其实现原理getLogger的时候会去classpath下找org/slf4j/impl/StaticLoggerBinder.class,即所有slf4j的实现,不同的日志框架在提供的jar包中一定是有这个文件的  
同样ResourceManager类用的 Log LOG = LogFactory.getLog(ResourceManager.class); 是属于commons-logging的,也是一个日志标准.太难,以后再整理  

这里声明了两个Logger LOG是记录正常日志,LOG_DEPRECATION 是记录不推荐的配置日志?  

### TAGS
private static final Set<String> TAGS = ConcurrentHashMap.newKeySet();  
ConcurrentHashMap 这个类源码有6k多行,都不是人看的,记住这个声明了一个线程安全的Set.  

### 普通属性
作用暂时不确定,后面补充

    private boolean quietmode = true;
    private static final String DEFAULT_STRING_CHECK = "testingforemptydefaultvalue";
    private static boolean restrictSystemPropsDefault = false;
    private boolean retrictSystemProps = restrictSystemPropsDefault;
    private boolean allowNullValueProperties = false;  

    //配置文件列表
    private ArrayList<Resource> resources = new ArrayList<Resource>();
    static final String UNKNOWN_RESOURCE = "Unknown";

    //不清楚
    private Set<String> finalParameters = Collections.newSetFromMap(new ConcurrentHashMap<String, Boolean>());
    private boolean loadDefaults ;
    //WeakHashMap 这个类网上原理分析的挺多的,应用的都是些大项目的代码
    //
    private static final WeakHashMap<ZConfiguration,Object> REGISTRY = new WeakHashMap<>();
### Resource
单个配置文件类  
private static class Resource{}

private ArrayList<Resource> resources = new ArrayList<Resource>();
