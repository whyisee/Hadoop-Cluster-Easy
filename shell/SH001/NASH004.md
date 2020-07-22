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

cd  


continue  

eval  

exec  

exit  

export  

getopts  

pwd  

readonly  

return  

shift  

test  

times  

trap  

umask  

unset  



## bash builtins commands

## modifying shell behavior

## special builtins