---

title: "Java简单学习-ThreadPoolExecutor"
scp: 2020/7/10 23:35:40
tags: java,thread  

---

# ThreadPoolExecutor

## Executor
最底层的一个接口,只有一个方法
void executor (Runnable command);  

## Future<V>  
执行任务的返回结果  
boolean cancel(boolean mayInterruptIfRunning);  
boolean isCancelled();  
boolean isDone();  
V get();  
V get(long timeout,TimeUnit unit);

## Runnable
只有一个方法  
public abstract void run();  

## RunableFuture<V> extends Runnable,Future<V>
void run();
## Callable<V> 
只有一个方法  
V call() ;

## FutureTask<V> implements RunnableFuture<V>  
```java
private volatile int state;  
//注释中的状态转换情况 
//NEW -> COMPLETING -> NORMAL  
//NEW -> COMPLETING -> EXCEPTIONAL  
//NEW -> CANCELLED  
//NEW -> INTERRUPTING -> INTERRUPTED  
private Callable<V> callable;
private Object outcome;
private volatile Thread runner;
//简单的链表节点
private volatile WaitNode waiters;

//返回V(outcome)
private V report (int s) ;


public  FutureTask(Callable<V> callable);

public FutureTask(Runnable runnable,V result);

public boolean isCancelled();

public boolean isDone();

public boolean cancel(boolean mayInterruptIfRunning);
//
//代码中有UNSAFE内容,暂时先跳过

public V get();
public V get(long timeout,TimeUnit unit);

protected void(){};

protected void set(V);

protected void setException();

public void run();

protected boolean runAndReset();

private void handlePossibleCancellationInterrupt(int s);

private void finishCompletion();

private int awaitDone(boolean timed,long nanos);

private void removerWaiter(WitNode node)

```

## ExecutorService extends Executor
继承Executor 的一个接口,其中的方法比较全面  
```java
void shutdown();  
List<Runnable> shutdownNow();  
boolean isShutdown();
boolean isTerminated();  
boolean awaitTermination(long timeout,TimeUnit);  
<T> Future<T> submit(Callable<T> task);
<T> Future<T> submit(Runnable task ,T result);
<T> Future<T> submit(Runnable task );
<T> List<Future<T>> invokeAll(Collection<? extends Callable<T>> tasks);
<T> T invokeAny(Collection<? extends Callable<T>> tasks);


```


