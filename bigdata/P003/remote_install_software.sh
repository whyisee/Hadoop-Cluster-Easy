#!/bin/sh

#批量安装软件,配置环境变量

#root用户下-安装到指定用户,指定目录

#1.准备好安装包
#2.指定安装程序
#3.指定 user@IP:path

#echo ""

read -p "请输入安装包路径:" software_path
#cd ${software_path}
read -p "请输入安装程序:" software_name
ls -rtl ${software_path}/*${software_name}*
read -p "请输入完整安装包名:" software_name_z
read -p "请输入安装位置 user@IP:path:" install_path
host_user=$(echo ${install_path} | awk -F "@" '{print $1}')
host_addr=$(echo ${install_path} | awk -F "@" '{print $2}' | awk -F ":" '{print $1}')
host_path=$(echo ${install_path} | awk -F "@" '{print $2}' | awk -F ":" '{print $2}')
#echo $host_path
software_name_p=$(tar -tf ${software_path}/${software_name_z}  |head -n1)
software_name_h=$(echo $software_name | tr a-z A-Z)_HOME
if [ $software_name_h = "HADOOP_HOME" ];then
host_cmd_path='export PATH=$PATH:$HADOOP_HOME/sbin'
fi

host_cmd="echo '解压...' ;
tar -xzf /tmp/${software_name_z} -C ${host_path} ;
echo '修改用户...' ;
chown ${host_user}:${host_user} -R ${host_path}/${software_name_p}; 
echo '配置环境变量...';
echo '#${software_name}配置' >> \$(eval echo ~${host_user})/.bash_profile ;
echo 'export $software_name_h=$host_path/$software_name_p' >> \$(eval echo ~${host_user})/.bash_profile ;
echo 'export PATH=\$PATH:\$$software_name_h/bin' >> \$(eval echo ~${host_user})/.bash_profile ; 
echo '$host_cmd_path' >> \$(eval echo ~${host_user})/.bash_profile ; 
echo 'export PATH' >> \$(eval echo ~${host_user})/.bash_profile ; " ;



scp ${software_path}/${software_name_z} root@${host_addr}:/tmp

ssh root@${host_addr} "$host_cmd"
