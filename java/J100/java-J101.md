---

title: "Java简单学习-Timer"
scp: 2020/7/8 23:35:40
tags: java,Timer  

---

这个类的用法比较简单:  
1.继承TimeTask,写好自己的Task类  
2.创建一个Timer对象  
3.time.schedule(yourTask,firstTime,cycle)  

![类图](http://ww1.sinaimg.cn/large/0066tqialy1ggkggic1qlj30qh0tptcs.jpg)

代码的关键点有:  
1.Timer 对象有一个任务队列queue,存放需要执行的任务  
2.Timer 对象有一个TimerThread,用来执行任务,其中mainLoop为主要代码  
3.TimerThread执行调度时会先对queue加锁,获取到其中的某个Task之后,再对Task的状态加锁,等待到task的执行时间开始执行  
4.TimerQueue代码中主要的代码有fixUp,fixDown,Task执行或取消后更改queue队列信息  
5.TimerThread是单线程的,所以如果任务阻塞会影响后面的任务  

![mainLoop](http://ww1.sinaimg.cn/large/0066tqialy1ggkghaswisj30kl0ulq4u.jpg)

了解Timer是了解调度的基础,一个任务调度该有的内容包括:  
1.任务统一调用(实现TimerTask)  
2.设定任务第一次执行时间  
3.设定任务周期执行的时间间隔  
4.任务执行状态的变更(加锁,保证安全)  
5.一个稳定的任务执行进程/线程,任务之间最好互相不干扰  

由于Timer存在一些不足,java5.0后增加了ScheduledThreadPoolExecutor多线性调度执行器,hadoop源码中使用的也多是该调度器,  
那么接下来就是 ScheduledThreadPoolExecutor 的分析


