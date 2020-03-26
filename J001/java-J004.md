---

title: "Java系统学习017-线程池相关(一)"
scp: 2020/2/19 23:35:40
tags: java,线程池  

---

## 线程池相关  

最近面试几次都被问到,还每次都不会.  

### 线程  

创建方法  

1. 继承Thread类  

2. 实现Runnable接口  

看了眼源码,Thread类也是实现了Runnable接口  
工地英语翻译下Thread类的源码注释介绍  
线程是程序中的执行线程...,java虚拟机允许一个应用有多个线程同时执行.  每个线程都有优先级,优先级高的线程比优先级第的线程更早执行,有的线程也可能被用作守护线程.  程序执行时如果一个线程里创建了一个新的线程,那么这个新线程的初始优先级和创建他的线程一致.守护线程只能由守护线程创建???  
当JVM启动时,通常会有一个非守护线程的线程(由指定的类的main()函数调起).JVM继续执行线程直到以下几种情况:  

* 指定类的exit()函数被执行,并且安全管理者允许退出发生.  

* 所有的非守护线程都执行完,所有的线程都从run函数中返回,或者抛出异常.  

有两种方式创建一个线程执行.第一种是声明一个类,并且属于Thread类的子类,这个类中需要重写run()函数.下面是一个例子balabala...

另一种方法是实现Runnable接口,并且重写run()函数.比如...  

每一个有一个名字,用来被识别.超过一个线程可能会有重复的名称.如果线程名在创建时没有被明确定义,java会自动给他生成.  

除非另外的公告,传入一个null参数给构造函数,会抛出NullPointerException异常

```java
public class ZThread extends Thread {
    public void run(){
        System.out.println("Test--------13:16--->:"+"thread is run...");
    }

}

public class ZRThread implements Runnable {
    @Override
    public void run() {
        System.out.println("Test--------13:27--->:"+"my runnable is run...");
    }
}


public class ZThreadTest {
    @Test
    public void threadTest(){
        ZThread zThread = new ZThread();
        zThread.start();

        ZRThread zrThread = new ZRThread();
        Thread zrThread2 = new Thread(zrThread);
        zrThread2.start();
    }

}

```

## 源码  

首先Runnable最简单,真就只有一个run()函数  
然后是Thread类,继承了Runnable  

第一个方法...  
简单说Java有两种方法：Java方法和本地方法。Java方法是由Java语言编写,也就是我们常见的放到,本地方法是由其他语言编写的,一般为c/c++,编写成动态库,通过System.loadLibrary()可以将包含本地库的文件动态加载进来.native 关键字修饰的方法就是本地方法,在java中没有{},没有具体的实现.registerNatives() 作用是在类加载的时候就注册本类中的本地方法,这样就不用在使用时候去加载本地库文件,等等好处多多.

```java
private static native void registerNatives();
    static {
        registerNatives();
    }
```

变量定义  

```java
//volatitle关键字,保证可见性,没搞懂
private volatile String name;
//优先级
private int            priority;
//
private Thread         threadQ;
//
private long           eetop;
//是否为单步线程
private boolean     single_step;
//是否为守护线程
private boolean     daemon = false;
//JVM状态?
private boolean     stillborn = false;
//要执行的东西
private Runnable target;
//线程组
private ThreadGroup group;
//线程类加载器上下文
private ClassLoader contextClassLoader;
//
private AccessControlContext inheritedAccessControlContext;
//...太多了吧

//记录点能看懂的
// 让出cpu时间片,重新竞争资源
public static native void yield();

//让当前执行的线程睡眠(暂时停止执行),指定睡眠的时间,不释放资源
public static native void sleep(long millis) throws InterruptedException;

//加上纳秒精度
public static void sleep(long millis, int nanos) throws InterruptedException{};

//初始化
private void init(ThreadGroup g, Runnable target, String name,
                      long stackSize, AccessControlContext acc,
                      boolean inheritThreadLocals) {}
//还不支持
protected Object clone() throws CloneNotSupportedException {}

//构造函数
public Thread() {
        init(null, null, "Thread-" + nextThreadNum(), 0);
    }

public Thread(Runnable target) {
        init(null, target, "Thread-" + nextThreadNum(), 0);
    }
//
public synchronized void start() {}

//

//输出的是线程名+优先级+[组名]
public String toString() {}


```
