---

title: "大数据集群搭建003-P002免密登录"
scp: 2018/9/24 23:35:40
tags:

---

先上脚本



由于默认的使用的root用户权限太大,正常的服务器上肯定不会用root用户安装软件的,某些教程为方便处理权限问题,直接使用root用户开始,那都是坑.  
首先创建用户  
>adduser 用户名  

设置密码  
>passwd 用户名  

创建秘钥,默认保存位置
>echo -e "\n" |ssh-keygen -t rsa -P ''

复制秘钥-免密互登
>ssh-copy-id  user_name@id


这里用对需要交互的部分可以使用管道处理,减少交互次数
>(echo $user_passwd ; sleep 1 ;echo $user_passwd )|passwd $user_name  >> /dev/null


附上实现部分功能的脚本





下载地址:[点击下载](https://github.com/whyisee/Hadoop-Cluster-Easy/releases/download/P002/add_sudo_user_remote.sh)
