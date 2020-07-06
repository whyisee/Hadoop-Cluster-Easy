#!/usr/bin/env python

import pandas as pd
from sklearn.feature_selection import VarianceThreshold
from scipy.stats import pearsonr
import matplotlib.pyplot as plt

def variance_demo():
    data = pd.read_csv("f:\\git\\myGit\\Hadoop-Cluster-Easy\\AI001\\factor_returns.csv")
    print(data)

    transfer = VarianceThreshold(threshold=1)
    result = transfer.fit_transform(data.iloc[:,1:10])
    print("删除低方差特征的结果:\n",result)
    #print("形状:\n",transfer.)

    print("形状:\n",result.shape)
    return None

def pearsonr_demo():
    data = pd.read_csv("f:\\git\\myGit\\Hadoop-Cluster-Easy\\AI001\\factor_returns.csv")
    factor = ['pe_ratio', 'pb_ratio', 'market_cap', 'return_on_asset_net_profit'
    , 'du_return_on_equity', 'ev','earnings_per_share', 'revenue', 'total_expense']

    for i in range(len(factor)):
        for j in range(i,len(factor)-1):
            print("指标%s与指标%s之间的相关性大小为%f" % (factor[i],factor[j+1],pearsonr(data[factor[i]],data[factor[j+1]])[0]) )
    
    plt.figure(figsize=(20,8),dpi=100)
    plt.scatter(data['revenue'],data['total_expense'])
    plt.show()
    
    return None


#variance_demo()
pearsonr_demo()