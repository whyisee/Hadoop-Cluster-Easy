#!/bin/sh

#为啥zookeeper是每台主机单独启动?

#程序很好实现,考虑的是如何实现通用


ssh hadoop@hadoop01 ". ~/.bash_profile ;/opt/apache-zookeeper-3.5.5-bin/bin/zkServer.sh restart"
ssh hadoop@hadoop02 ". ~/.bash_profile ;/opt/apache-zookeeper-3.5.5-bin/bin/zkServer.sh restart"
ssh hadoop@hadoop03 ". ~/.bash_profile ;/opt/apache-zookeeper-3.5.5-bin/bin/zkServer.sh restart"

