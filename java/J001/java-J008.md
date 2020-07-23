---

title: "Java系统学习021-注解"
scp: 2020/7/23 17:35:40
tags: java,注解  

---

# 注解

## 目标
1. 知道什么是注解  
2. 能看懂注解  
3. 能写注解

## 简介  
### 注解是什么
注解本身的源码在java.lang.annotation,是个很普通的接口  
看Override注解的代码
```java
package java.lang;
import java.lang.annotation.*;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface Override {
}
```
就是这么简单的几行代码,为啥能实现检测方法是否重新的功能呢  
为了看懂这几行代码,先了解一点后面的东西--元注解  
简单说:
- @Target 注解的作用目标,这里指该注解作用于方法上
- @Retention 注解的保留级别 ,这里指该注解只会源代码级别保留,编译时就会被忽略
- @interface 不是元注解,声明这是个注解

注解的逻辑实现是元数据的用户来处理的，注解仅仅提供它定义的属性（类/方法/变量/参数/包）的信息，注解的用户来读取这些信息并实现必要的逻辑.所以@Override的逻辑实现使用jvm实现的,我们只需要知道他的作用.  



## java常用注解  

## java元注解

## 自定义注解

## 其他注解
