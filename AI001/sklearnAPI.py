#!/usr/bin/env python

from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split


def datasets_demo():
    #1.获取鸢尾花数据集
    iris = load_iris()
    print("...")

    #2.对鸢尾花数据镜集分隔
    x_train,x_test,y_train,y_test = train_test_split(iris.data,iris.target,random_state=22)
    print("x_train:",x_train.shape)

    #随机种子
    x_train1,x_test1,y_train1,y_test1 = train_test_split(iris.data,iris.target,random_state=6)
    x_train2,x_test2,y_train2,y_test2 = train_test_split(iris.data,iris.target,random_state=6)
    print("随机种子不一样",x_train==x_train1)
    print("随机种子一样"  ,x_train1==x_train2)


    return None

datasets_demo()