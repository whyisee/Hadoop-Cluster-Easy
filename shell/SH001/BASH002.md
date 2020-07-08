---

title: "bash笔记002-5. shell variables"
scp: 2020/7/7 23:35:40
tags: bash  

---

# shell variables

## 1. bourne shell variables (sh variables)

**CDPATH**  这个默认为空,如果设置了路径之后,默认会设置的路径开始查找,可设置多个,冒号分隔,如:
```bash

CDPATH=/tmp
mkdir -p /tmp/test
cd test
pwd
#/tmp/test

```

**HOME**

**IFS**

**MAIL**

**MAILPATH**

**OPTARG** getopts 脚本参数选项处理工具使用

**OPTIND**

**PATH**

**PS1** 脚本左侧的提示符

**PS2** 输入cat类的命令时的第二提示符


## 2. bash variables

**BASH** bash路径

BASHOPTS  
shopt 开启的选项 ,shopt 不知


BASHPID


BASH_ALIASES
一个关联数组变量，其成员对应于别名内置由别名内置维护的内部列表。
添加到该数组的元素将出现在别名列表中； 但是，取消设置数组元素当前不会导致别名从别名列表中删除。 如果未设置BASH_ALIASES，则即使随后将其重置，它也会失去其特殊属性。
查看数组所有数据echo ${BASH_ALIASES[@]}
该数组中保持了所有的别名,即 alias 打印内容
总结:没啥用  


BASH_ARGC
一个数组变量，其值是当前bash执行调用堆栈每一帧中的参数数。  
当前子例程（使用。或source执行的shell函数或脚本）的参数数量位于堆栈的顶部。
当执行子例程时，传递的参数数量将推入BASH_ARGC。 仅在扩展调试模式下，shell才设置BASH_ARGC

BASH_ARGV

BASH_ARGV0