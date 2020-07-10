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

## FutureTask<V> implements RunnableFuture<V>  



## ExecutorService extends Executor
继承Executor 的一个接口,其中的方法比较全面  
void shutdown();  
List<Runnable> shutdownNow();  
boolean isShutdown();
boolean isTerminated();  
boolean awaitTermination(long timeout,TimeUnit);  
<T> Future<T> submit(Callable<T> task);


