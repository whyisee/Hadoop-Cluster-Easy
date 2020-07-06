#!/bin/env python

import urllib.parse      #负责url编码处理
import urllib.request
from lxml import etree
import os

def loadPage(url, filename):
    """
        作用：根据url发送请求，获取服务器响应文件
        url: 需要爬取的url地址
        filename : 处理的文件名
    """
    #print ("正在下载 " + filename)
    headers = {"User-Agent" : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.62 Safari/537.36"}

    request = urllib.request.Request(url, headers = headers)
    return urllib.request.urlopen(request).read()


def writePage(html, filename):
    """
        作用：将html内容写入到本地
        html：服务器相应文件内容
    """
    print ("正在保存 " + filename)
    # 文件写入
    with open(filename, "wb+") as f:
        f.write(html)
    print ("-" * 30)

html=loadPage("https://www.zhihu.com/search?q=%E9%99%A4%E5%A4%95%E7%A5%9D%E7%A6%8F&utm_content=search_hot&type=content","bilibili排行")
writePage(html,'bilibili排行.html')