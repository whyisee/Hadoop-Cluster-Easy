---

title: "大数据集群搭建002-P001网络配置"
scp: 2018/9/13 23:35:40
tags:VirtualBox,linux,Network  

---


## 大数据集群搭建002-P001网络配置

本手册目的是通过一些脚本或工具,来完成那些看下的很复杂但是却只需按部就班执行一大堆命令的步骤.理论上讲,网络配置也是可以写个脚本,但是没配置好网络就没法把脚本放到服务器上,这就很无奈了,还有一种办法可以整合到系统镜像中,不过目前能力不足,暂不考虑,所以老老实实手工配置吧.

以下及后续所有配置是基于使用VirtualBox虚拟机软件安装Redhat6.5 32位操作系统的配置,使用其他系统配置可能稍有差异

1.虚拟机新建一个32位的RedHat虚拟主机  
2.配置两块网卡,第一块用默认网络地址转换(NET),第二块启用选择仅主机(Host-Only)网络  
![两块网卡](http://ww1.sinaimg.cn/large/0066tqialy1fvc6oxmxwvj30oe0e6dgj.jpg)  
3.root用户登录  
4.配置  
这套配置是参考VirtualBox自带帮助(F1查看)完成的,有兴趣的可以研究下,说不定可以找到比这简单方便的配置.  

4.1两个网卡配置  
网卡1: /etc/sysconfig/network-scripts/ifcfg-eth0  
> DEVICE=eth0  
HWADDR=08:00:27:35:E4:F6  
TYPE=Ethernet  
UUID=35169346-8807-4434-b02a-c9d6792935e8  
ONBOOT=yes  
NM_CONTROLLED=yes  
BOOTPROTO=static  
IPADDR=10.0.2.133  
NETWORK=10.0.2.2  
NETMASK=255.255.255.0  
GATEWAY=10.0.2.2  
DNS1=114.114.114.114 
BROADCAST=10.0.2.255  

网卡2:/etc/sysconfig/network-scripts/ifcfg-eth1  
默认是没有这个文件的,需手工创建,HWADDR 需执行 ` ifconfig -a` 查看
>DEVICE=eth1  
HWADDR=08:00:27:0F:28:03  
TYPE=Ethernet  
UUID=35169346-8807-4434-b02a-c9d6792935e8  
ONBOOT=yes  
NM_CONTROLLED=yes  
BOOTPROTO=static  
IPADDR=192.168.56.133  
NETWORK=192.168.56.1  
NETMASK=255.255.255.0  
GATEWAY=192.168.56.1  
DNS1=114.114.114.114  
BROADCAST=192.168.56.255  

DNS:可以改为速度更快的服务器,或者路由器地址  

4.2静态路由配置  
>echo any net 0.0.0.0 netmask 0.0.0.0 gw 10.0.2.2 >> /etc/sysconfig/static-routes     

5.重启网络服务

> service  network restart 

简单的网络配置就是这些,配置好网络之后就可以通过ssh连接工具连接,ftp工具传输文件,这里推荐[SecureCRT](https://pan.baidu.com/s/1UPTE4a7nAXRSYOP0yR6wWA)和[WinSCP](https://winscp.net/eng/docs/lang:chs),留个下载地址方便以后找资源.