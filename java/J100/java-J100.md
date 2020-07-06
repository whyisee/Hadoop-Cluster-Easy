---

title: "Java简单学习-开始篇"
scp: 2020/2/19 23:35:40
tags: java,LinkedList  

---

## 原因  

前有系统学习,奈何半途而废,现在简单学习,只学其然不学其所以然  

接触的到的东西越来越多,很多技术之间都会有交叉,如果每次遇到新的不了解的技术都要系统的学习一遍整个技术,自然是不现实的.  

java确实很强,确实需要系统学习,奈何目前已经工作,需要学习的东西太多(都是借口),只能先囫囵学个大概.  

在此依然挖坑,待整理好完善的学习计划后,定将java好好系统学一遍.  

## java8新特性  

### 1.函数式接口  

#### Function接口  

只有4个方法  

```java
    //需实现,实际的函数的操作,入参是函数的入参,返回的是函数的结果
    R  apply(T t){}

    //有默认实现,传入一个函数,先通过本函数的apply处理操作,把返回结果传给传入函数的apply处理
    default <V> Function <T,V> andThen(Function<? super R,? extend V> after){
                return (V v) -> after.apply(apply(v))
    }


    //有默认实现,传入一个函数,先处理传入函数的操作,把返回结果传给本函数的apply处理
    default <V> Function<V,R> compose(Function<? super V,? extend T> before){
        return (V v) -> apply(before.apply(v))
    }

    //相当于普通的静态方法,也是java8新特性,返回函数本身,不知道有啥用
    static <T> Function<T,T> identity(){
        return t -> t;
    }
```

其中的default关键字和接口中的static修饰方法都是java新特性.  


