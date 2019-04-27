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




