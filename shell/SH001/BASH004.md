---

title: "bash笔记004-4. shell builtin commands"
scp: 2020/7/22 23:35:40
tags: bash  

---

# shell builtin commands

## bourne shell builtins

:  
什么都不干,可以起占位和变量扩展和重定向的作用  
变量扩展如:
给VAR设置默认值,如果不加: ,会被shell当成命令来执行
: ${VAR:default}

.  
如果文件不到/,则从PATH中寻找文件,

break  
break [n]
退出for,while,select
```bash
select i in $(seq 5) ;
do
echo $i
done

#会显示序号,ctrl+d 退出,通常和case in 一起使用

```


cd  
cd [-L|[-P [-e]]] [-@] [directory]  
1. 切换当前目录,如果不带参数,会进入到$HOME 所在目录  
```bash
# 下面三个命令效果一样的
cd 
pwd
cd ~
pwd
cd $HOME
pwd

# 再来几个其他的
cd ~- # = cd - 或者 cd $OLDPWD
cd ~+ # = cd . 或者 cd $PWD 

```
2. 注意如果有$CDPATH这个自带变量有值的话,会优先从CDPATH的值的目录下寻找目录,CDPATH支持设置多个目录,使用:分隔,不过一般也不会用这个,结果太奇怪了  
```bash
# 最后进入了/tmp/test1/test2而不是当前目录(/tmp)下的test2
mkdir -p /tmp/test1/test2
mkdir -p /tmp/test2
cd /tmp
CDPATH=/tmp/test1
pwd
#/tmp
cd  test2
pwd
#/tmp/test1/test2
```
3. -L 和 -P 是相对于符号链接路径时会有所区别,默认或者加上-L参数,会进入到符号链接的路径,加上-P 进入的就是真实路径.  
```bash
# cd -P /root/test3 显示的是真实的路径
mkdir -p /tmp/test1/test2
ln -s /tmp/test1/test2 /root/test3
cd  /root/test3
pwd
cd -L /root/test3
pwd
cd -P /root/test3
pwd
```

4. .. 代表上一级目录,如果是在根目录,返回的还是根目录
```bash
# 最后返回的还是根目录/
mkdir -p /tmp/test1/test2
cd /tmp/test1/test2
pwd
cd ..
pwd
cd ../../../../../
pwd
```
5. cd -P -e  下面是bash官方原文,目前只发现一种使用情况:  
当前所在目录被删除了,执行cd . 控制台有报错,但是返回的状态还是0正常,而如果执行cd -P -e . 返回的状态则是1异常  
If the -e option is supplied with -P and the current working directory cannot
be successfully determined after a successful directory change, cd will return
an unsuccessful status.

```bash
## $? 上一条命令的返回值
## !$ 上一条命令的最后一个参数
[root@master tmp]# mkdir -p /tmp/test1/test2/test3
[root@master tmp]# cd !$
cd /tmp/test1/test2/test3
[root@master test3]# pwd
/tmp/test1/test2/test3
[root@master test3]# rm -rf  /tmp/test1/test2/test3
[root@master test3]# pwd
/tmp/test1/test2/test3
[root@master test3]# cd .
cd: error retrieving current directory: getcwd: cannot access parent directories: No such file or directory
[root@master .]# echo $?
0
[root@master .]# pwd
/tmp/test1/test2/test3/.
[root@master .]# cd -P -e .
cd: error retrieving current directory: getcwd: cannot access parent directories: No such file or directory
[root@master ]# echo $?
1
```
6.  cd - 返回上一个工作目录,也就是$OLDPWD中保持的路径, cd -- -d ,进入-d 目录,两个- 使后面的-当做参数而非选项
```bash
[root@master tmp]# pwd
/tmp
[root@master tmp]# mkdir -p /tmp/test1
[root@master tmp]# cd test1
[root@master test1]# pwd
/tmp/test1
[root@master test1]# cd -
/tmp
[root@master tmp]# mkdir -- -d
[root@master tmp]# cd -- -d
[root@master -d]# pwd
/tmp/-d

```
cd -@ 这个需要在支持的系统上生效,目前还没不知道用法


### continue  
结束当前循环,进入下一次循环(for,while,untile,select),如果有多层循环,则可加上数字,指定第几层  



### eval  [arguments]
这个命令原以为很复杂,没想到连个选项都没有,作用呢就是将后面的参数当作命令执行,接收命令的返回值返回,如果没有参数,则返回0,经过测试,eval不接收管道传递的数据  

不过eval的用法还是挺多的,记忆最深的就是多个变量同时赋值
```bash
#基础版,三个变量同时赋值,感觉很鸡肋,分开写不香吗
eval a=1;b=2;c=3 

#进阶版,有点东西了,最开始见到这个用法的时候是前面的echo换成了查数据库的函数,后面的赋值变量有7个,看的有点蒙
eval $(echo 1,2,3 |awk -F "," '{print "a="$1";b="$2";c="$3";"}') 

#eval 可以接收多个参数,但是其中一个报错,则其他都不执行
eval a=1 b=2 c=3 #正常
eval a=1 b c=3  #都不执行,返回异常

#eval 用的较少,其他的用法还没遇到过
```

### exec  
exec [-cl] [-a name] [command [arguments]]

exec 这个命令用的稍微多一些,不过个人还是更习惯用xargs,稍后会总结下二者的区别  


exit  

export  

getopts  

pwd  -

readonly  

return  

shift  

test  

times  

trap  

umask  

unset  



## bash builtins commands

alias  

bind  

builtin  

caller

command  

declare  

echo  


enable  

help  

let  

local  

logout  

mapfile  

printf  


read  

readarray  

source  

type  

typeset  

ulimit  

unalias  



## modifying shell behavior

set  

shopt  


## special builtins

bread  

:  

.  
