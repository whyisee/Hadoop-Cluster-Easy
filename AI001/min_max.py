#!/usr/bin/env python

import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from sklearn.preprocessing import StandardScaler


def min_max_demo():
    data = pd.read_csv("f:\\git\\myGit\\Hadoop-Cluster-Easy\\AI001\\dating.txt")
    print(data)

    transfer = MinMaxScaler(feature_range=(2,3))

    result = transfer.fit_transform(data[['milage','Liters','Consumtime']])

    print("最小值最大值归一化结果:\n",result)

    return None

def stand_demo():
    data = pd.read_csv("f:\\git\\myGit\\Hadoop-Cluster-Easy\\AI001\\dating.txt")
    print(data)
    transfer = StandardScaler()
    result = transfer.fit_transform(data[['milage','Liters','Consumtime']])
    print("标准化化结果:\n",result)
    print("每一列特征的平均值:\n",transfer.mean_)
    print("每一列特征的方差:\n",transfer.var_)

#min_max_demo()
stand_demo()