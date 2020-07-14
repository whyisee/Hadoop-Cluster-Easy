---

title: "Java系统学习018-泛型"
scp: 2020/7/14 17:35:40
tags: java,E  

---

# 泛型  

## 泛型类  

## 泛型方法

## 类型变量的限定

## 泛型代码和jvm

## 约束和局限性  

### 1. 不能使用基本类型实例化类型参数  
不能用类型参数代替基本类型.原因是类型擦除,擦除之后,没有限定类型的变量编译成Object类型的域,Object类型只能存储引用,不能存储基本类型的值.  
可以使用包装器类型替代  

### 2. 运行时的类型查询只适用于原始类型  
List<String> list1 = ...;
List<Integer> list2=...;
list1.getClass()==list2.getClass();  

### 3. 不能创建参数化类型的数组  
Pair <String>[] table = new Pair<String>[10]; //error  
应为擦除类型之后table就是Pair 类型的,可以转换成Object[] ;
Object[] o = table;  
此时试图纯粹其他类型的元素时就会抛出异常.  

可以使用ArrayList:ArrayList<Pair<String>>实现效果;  

### 4. Varargs警告  


