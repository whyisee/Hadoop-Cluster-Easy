---

title: "Java简单学习-WeakHashMap"
scp: 2020/7/28 23:35:40
tags: java,Map  

---

# WeakHashMap

## 简介
一般的map中的key是不会被清理的,只有等到map不在被引用之后,才有可能被清理  
而WeakHashMap 中的key是弱引用类型,那么就有可能会被GC清理,基于这种特性,WeakHashMap适合用来做缓存相关的场景

## 源码分析

## 应用实例