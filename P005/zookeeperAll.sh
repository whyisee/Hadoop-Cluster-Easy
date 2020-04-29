#!/bin/env bash 
#. functions.sh

#/************************************************************************************
# 功能描述: 支持启动其他节点zookeeper
# 执行说明: 
# 输入参数: 日期 yyyymmdd 如:20190601
# 输出结果: 
# 创建人员: zoukh
# 创建日期: 2020-04-28 21:07:57
# 修改人员: zoukh
# 修改日期: 2020-04-29 11:19:41
#/************************************************************************************
#
# ( ･_･)ﾉ⌒●~* 注释写的少,bug改不好 *~●⌒㇏(･_･ ) 
#

operation=$1
nodes=$2
if [ "Z$nodes" = "Z" ];then
nodes=localhost
fi
nodes=$(echo $nodes|sed "s/,/ /g")

#以登陆bash方式创建bash,可以避免环境变量未加载
for node in $nodes ;do
ssh $node "bash -l /opt/apache-zookeeper-3.5.5-bin/bin/zkServer.sh $operation"
done