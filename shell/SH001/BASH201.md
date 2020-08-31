---

title: "bash笔记201. tput"
scp: 2020/7/22 23:35:40
tags: bash  

---


tput clear # 清屏
tput sc # 保存当前光标位置
tput cup 10 13 # 将光标移动到 row col
tput civis # 光标不可见
tput cnorm # 光标可见
tput rc # 会到光标记录位置

在指定位置输出信息,再回到原位置
(tput sc ; tput cup 23 45 ; echo “Input from tput/echo at 23/45” ; tput rc)


tput civis #隐藏光标
tput cnorm #显示光标

0：黑色
1：蓝色
2：绿色
3：青色
4：红色
5：洋红色
6：黄色
7：白色

tput setb 6  #背景色
tput setf 4  #前景色
tput blink      # 文本闪烁
tput bold       # 文本加粗
tput el         # 清除到行尾
tput smso       # 启动突出模式
tput rmso       # 停止突出模式
tput smul       # 下划线模式
tput rmul       # 取消下划线模式
tput sgr0       # 恢复默认终端
tput rev        # 反相终端



