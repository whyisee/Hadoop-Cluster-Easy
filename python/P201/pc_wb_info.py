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
    headers = {"User-Agent" : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36"
                ,"Referer" : "https://passport.weibo.com/visitor/visitor?entry=miniblog&a=enter&url=https%3A%2F%2Fweibo.com%2F&domain=.weibo.com&ua=php-sso_sdk_client-0.6.28&_rand=1577801952.8959"}

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

html=loadPage("https://weibo.com/visitor/visitor?a=incarnate&category=10011","web")
writePage(html,'web.html')