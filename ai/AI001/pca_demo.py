#!/usr/bin/env python

from sklearn.decomposition import PCA

def pca_demo():
    data = [[2,8,4,5], [6,3,0,8], [5,4,9,1]]

    #1.实例化PCA, 小数保留90%的信息
    transfer = PCA(n_components=0.9)

    result1 = transfer.fit_transform(data)

    print("保留90%,降维结果:\n",result1)

    #2.实例化PCA, 整数指定降到的维数
    transfer2 = PCA(n_components=3)
    result2 = transfer2.fit_transform(data)

    print("降到3维的结果:\n",result2)

    return None

pca_demo()