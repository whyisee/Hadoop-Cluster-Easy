#!/usr/bin/env python


import pandas as pd



# 加载数据
data1 = pd.read_csv("F:\python\AI/fresh_comp_offline/tianchi_fresh_comp_train_item.csv")
data2 = pd.read_csv("F:\python\AI/fresh_comp_offline/tianchi_fresh_comp_train_user.csv")


# 预处理
#print(data1.head())
#print(data2)

print(data1.shape)
