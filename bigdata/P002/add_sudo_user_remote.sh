#!/bin/sh

#增加用户,设置密码,免密sudo


#add_sudo_user_remote.sh

#

result_code="ERROR"

function display_start()
{
clear
echo "==========================请选择功能:====================="
echo
echo "a)===========本机增加用户"
echo
echo "b)===========远程主机增加用户"
echo
echo "c)===========本机创建密匙"
echo
echo "d)===========远程主机创建密匙"
echo
echo "e)===========免密互登"
echo
echo "s)===========sudo免密"
echo
echo "q)===========退出"
echo
echo -n "请输入(a):"
}

#sudo免密
function add_sudo_nopasswd()
{
	echo "请输入添加用户  用户名@IP:"
	read remote_addr
	user_name=$(echo $remote_addr |awk -F "@" '{print $1}')
	user_addr=$(echo $remote_addr |awk -F "@" '{print $2}')
	remote_cmd="chmod u+w /etc/sudoers  ;echo '$user_name ALL=(ALL)  NOPASSWD:  ALL' >> /etc/sudoers  ; chmod u-w /etc/sudoers ;"
	ssh root@${user_addr}  "${remote_cmd}"
	echo "sudo免密添加完成..."

	read
}

function add_ssh_key()
{
	echo "如果已有秘钥则跳过..."
	echo -e "\n" |ssh-keygen -t rsa -P ''
	echo "创建秘钥结束..."
	read
}

function add_ssh_key_remote()
{
	echo "如果已有秘钥则跳过..."
	echo "请输入远程主机  用户名@IP:"
	read remote_addr
	remote_cmd='echo -e "\n" |ssh-keygen -t rsa -P ""'
	ssh ${remote_addr} "${remote_cmd}"
	echo "创建秘钥结束..."
	read

}

function add_ssh_copy()
{
	echo "请输入互登主机1 用户名@IP ..."
	read remote_addr1
	echo "请输入互登主机2 用户名@IP ..."
	read remote_addr2
	# if [ Z"$remote_addr2" = "Z" ];then
	# remote_addr2=localhost
	# fi
	remote_cmd1="ssh-copy-id $remote_addr2 ;exit"
	echo -e "输入密码后请手动执行以下命令! \n $remote_cmd1"
	ssh ${remote_addr1} 
	remote_cmd2="ssh-copy-id $remote_addr1 ;exit"
	echo -e "输入密码后请手动执行以下命令! \n $remote_cmd2"
	ssh ${remote_addr2} 

	#echo -e "\n" |ssh-keygen -t rsa -P ''
	echo "免密互登配置结束..."
	read

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
result_code="OK"
sllep 5
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

#不要有复杂的if..else 判断

function add_user_passwd_remote()
{
if [ Z$result_code = "ZOK" ];then
	echo "是否复制上次设置?y/n"
	read v_choose
	if [ Z$v_choose = "Zy" ];then
		echo "正在复制配置..."
		sleep 2
		echo "..."
		echo "OK!"
	else
		echo "重新设置用户..."
		add_user_passwd_remote_before
	fi
else
add_user_passwd_remote_before
fi
echo "请输入远程IP:"
read remote_addr
ssh root@${remote_addr} "${remote_cmd}"

}

function add_user_passwd_remote_before()
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
remote_cmd1=" adduser $user_name ;"
remote_cmd2=" (echo $user_passwd ; sleep 1 ;echo $user_passwd )|passwd $user_name  >> /dev/null ;if [ $? = 0 ];then echo ;  echo 创建用户成功 ;  else echo ;echo 创建失败!   ;fi ;sleep 3"
remote_cmd=${remote_cmd1}${remote_cmd2}
result_code="OK"
break 2
else
echo "两次输入不一致,请重新输入!"
fi

done
done
}


for i in `seq 100` ;do
display_start
read  v_step


case $v_step in
	a)
	echo
	echo "增加本地用户开始..."
	echo
	add_user_passwd
	;;
	b)
	echo
	echo "增加远程用户开始..."
	echo
	add_user_passwd_remote
	;;
	c)
	echo
	echo "增加本机秘钥开始..."
	echo
	add_ssh_key
	;;
	d)
	echo
	echo "增加远程秘钥开始..."
	echo
	add_ssh_key_remote
	;;
	e)
	echo
	echo "免密互登配置开始..."
	echo
	add_ssh_copy
	;;
	s)
	echo
	echo "sudo配置开始..."
	echo
	add_sudo_nopasswd
	;;
	q)
	echo
	echo "退出程序..."
	echo
	exit 0
	;;
	*)
	echo
	echo "错误选项,请重新输入!"
	echo
	sleep 2
	;;
esac
	
	
	
	
	
	
	
	
	
	

##if [ Z$v_step = "Za" ];then
##echo
##echo "增加本地用户开始..."
##echo
##
##add_user_passwd
##
##elif [ Z$v_step = "Zb" ];then
##echo
##echo "增加远程用户开始..."
##echo
### ssh root@192.168.56.200 "adduser test ;(echo 123456 ;sleep 2 ;echo 123456)|passwd  test  "
##if [ Z$result_code = "ZOK" ];then
##echo "是否复制上次设置?y/n"
##read v_choose
##if [ Z$v_choose = "Zy" ];then
##echo "正在复制配置..."
##sleep 2
##echo "..."
##echo "OK!"
##else
##echo "重新设置用户..."
##add_user_passwd_remote
##fi
##else
##add_user_passwd_remote
##fi
##
##echo "请输入远程IP:"
##read remote_addr
##ssh root@${remote_addr} "${remote_cmd}"
###echo 111
##
##elif [ Z$v_step = "Zq" ];then
##echo
##echo "退出程序..."
##exit
##echo
###if [ $? = "0" ];then
##else 
##echo "错误选项,请重新输入!"
##sleep 2
##fi

done

