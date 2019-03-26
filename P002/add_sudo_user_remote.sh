#!/bin/sh

#增加用户,设置密码,免密sudo


#add_sudo_user_remote.sh

#

function display_start()
{
clear
echo "==========================请选择功能:====================="
echo
echo "a)===========本机增加用户"
echo
echo "b)===========远程主机机增加用户"
echo
echo "q)===========退出"
echo
echo -n "请输入(a):"
}



function add_user_passwd()
{
for i in `seq 10` ;do
echo "添加用户,请输入用户名(咱们是大数据集群建议统一用户名比如bigdata):"
read user_name

for j in `seq 10` ;do
echo "用户名为$user_name,请输入密码:"
read user_passwd
echo "用户名为$user_name,请重复上次密码:"
read user_passwd_r
if [ $user_passwd = $user_passwd_r ];then
adduser $user_name
if [ $? = "0" ];then
echo "创建用户成功!"
(echo $user_passwd ; sleep 1 ;echo $user_passwd )|passwd $user_name  >> /dev/null
if [ $? = "0" ];then
echo 
echo "设置密码成功"
break 2
echo "设置密码失败!"
break
fi
else
echo "创建失败!重新开始"
break 
fi

else
echo "两次输入不一致,请重新输入!"
fi

done
done

}

function add_user_passwd_remote()
{
for i in `seq 10` ;do
echo "添加远程用户,请输入用户名(注意:本脚本为了简单使用,远程新建用户有可能失败!):"
read user_name

for j in `seq 10` ;do
echo "用户名为$user_name,请输入密码:"
read user_passwd
echo "用户名为$user_name,请重复上次密码:"
read user_passwd_r
if [ $user_passwd = $user_passwd_r ];then
remote_cmd1=" adduser $user_name "
if [ $? = "0" ];then
echo "创建用户成功!"
remote_cmd2=" (echo $user_passwd ; sleep 1 ;echo $user_passwd )|passwd $user_name  >> /dev/null"
if [ $? = "0" ];then
echo 
echo "设置密码成功"
break 2
else
echo "设置密码失败!"
break
fi
else
echo "创建失败!重新开始"
break 
fi

else
echo "两次输入不一致,请重新输入!"
fi

done
done

}

for i in `seq 10` ;do
display_start
read  v_step

if [ Z$v_step = "Za" ];then
echo
echo "增加本地用户开始..."
echo
break
add_user_passwd

elif [ Z$v_step = "Zb" ];then
echo
echo "增加远程用户开始..."
echo
# ssh root@192.168.56.200 "adduser test ;(echo 123456 ;sleep 2 ;echo 123456)|passwd  test  "
echo "请输入远程IP:"
read remote_addr

ssh root@${remote_addr} add_user_passwd
echo 111

elif [ Z$v_step = "Zq" ];then
echo
echo "退出程序..."
exit
echo
#if [ $? = "0" ];then
else 
echo "错误选项,请重新输入!"
sleep 2
fi

done

