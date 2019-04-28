---

title: "大数据集群搭建002-P002_1 sudo免密,hosts修改"
scp: 2018/9/13 23:35:40
tags: linux,host ,sudo

---

### hosts修改
>echo "#集群hosts"  >> /etc/hosts  
echo 192.168.56.201 hadoop01 >> /etc/hosts  
echo 192.168.56.202 hadoop02 >> /etc/hosts  
echo 192.168.56.203 hadoop03 >> /etc/hosts  

修改后不需要重启  

### 主机名称修改
>/etc/sysconfig/network


### sudo 免密
>chmod u+w /etc/sudoers  
echo "hadoop ALL=(ALL)  NOPASSWD:  ALL" >> /etc/sudoers  
chmod u-w /etc/sudoers 

已加入工具脚本


### yum重新安装

检查yum是否安装，默认情况下都是安装好的，总共4各包
```bash
rpm -qa |grep yum
rpm -qa |grep yum |xargs rpm -e --nodeps #卸载
#下载 http://mirrors.163.com/centos/
#主要有
python-iniparse-0.3.1-2.1.el6.noarch.rpm 
yum-3.2.29-40.el6.centos.noarch.rpm
yum-metadata-parser-1.1.2-16.el6.x86_64.rpm
yum-plugin-fastestmirror-1.1.30-14.el6.noarch.rpm
rpm -ivh 
rpm -ivh  yum-metadata-parser-1.1.2-16.el6.x86_64.rpm 
rpm -ivh python-iniparse-0.3.1-2.1.el6.noarch.rpm
rpm -ivh  python-urlgrabber-3.9.1-11.el6.noarch.rpm yum-3.2.29-81.el6.centos.noarch.rpm yum-plugin-fastestmirror-1.1.30-41.el6.noarch.rpm
#下载配置文件CentOS6-Base-163.repo
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo 
 vi CentOS6-Base-163.repo #（使用 vi 命令编辑文件）

 ：%s/$releasever/6 


### mysql 安装
yum install mysql
yum install mysql-server


To start mysqld at boot time you have to copy
support-files/mysql.server to the right place for your system

PLEASE REMEMBER TO SET A PASSWORD FOR THE MySQL root USER !
To do so, start the server, then issue the following commands:

/usr/bin/mysqladmin -u root password 'new-password'
/usr/bin/mysqladmin -u root -h hadoop01 password 'new-password'

Alternatively you can run:
/usr/bin/mysql_secure_installation

which will also give you the option of removing the test
databases and anonymous user created by default.  This is
strongly recommended for production servers.

See the manual for more instructions.

You can start the MySQL daemon with:
cd /usr ; /usr/bin/mysqld_safe &

You can test the MySQL daemon with mysql-test-run.pl
cd /usr/mysql-test ; perl mysql-test-run.pl


```