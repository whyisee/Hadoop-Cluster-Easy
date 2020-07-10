---

title: "Java简单学习-TimeUnit"
scp: 2020/7/10 23:35:40
tags: java,TimeUnit  

---

# TimeUnit

这是个枚举类,由于对枚举类型一直不是太清楚,这里就统一整理一下  

## enum 枚举  



Java使用enum定义枚举类型，它被编译器编译为final class Xxx extends Enum { … }；  
通过name()获取常量定义的字符串，注意不要使用toString()；  
通过ordinal()返回常量定义的顺序（无实质意义）；  
可以为enum编写构造方法、字段和方法  
enum的构造方法要声明为private，字段强烈建议声明为final；  
enum适合用在switch语句中。  

## TimeUnit 中的枚举常量

NANOSECONDS  

MICROSECONDS  

MILLISECONDS  

SECONDS  

MINUTES  

HOURS  

DAYS  

每个常量中都包含了向不同格式转换的方法
toNanos()  
toMicros()  
toMillis()  
toSeconds()  
toMinutes()  
toHours()  
toDays()  
convert() 将其他格式转换为当前格式  
excessNanos()  
重写了sleep(),可以执行的更精确?


这个枚举类型在ScheduledThreadPoolExecutor中作用就是时间单位...  


