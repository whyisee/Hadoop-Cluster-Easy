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

def bookDownload(url,filePath,baseUrl):
    """
        作用：下载

    """
    html = loadPage(url,"33753")
    #"/txt/33727.htm"
    #writePage(html, "33753")
    dom = etree.HTML(html)
    a_text = dom.xpath('//li[@class="downAddress_li"]/a/@href')
   
    html = loadPage(baseUrl+a_text[0],"33753")
    #writePage(html, "33753_z")
    dom = etree.HTML(html)
    a_text = dom.xpath('//tr/td/a[@class="strong green"]/@href')  
    #print(a_text[0])
    html = loadPage(baseUrl+a_text[0],"33753")
    writePage(html, filePath)


def jiujiuSpider(url, href, filePath):
    """
        作用：爬虫调度器，负责组合处理每个页面的url
        url : url的前部分
        beginPage : 起始页
        endPage : 结束页
    """
    html = loadPage(url+"/"+href, href)
    pathName=href.split("/")[2]
    if not os.path.exists(pathName):
        os.mkdir(pathName)
    
    writePage(html, filePath+"/"+pathName+"/"+pathName+".html")

    beginPage=2
    endPage=10
    dom = etree.HTML(html)
    a_text = dom.xpath('//div[@id="catalog"]/div/a/@href')
    b_text = dom.xpath('//div[@id="catalog"]/div/a/@title')
    #print(b_text)
    #print(a_text)

    i=0
    for ele_book in a_text:
        print(b_text[i])
        bookDownload("https://www.jjxsw.la"+ele_book,pathName+"/"+b_text[i]+".txt","https://www.jjxsw.la")
        i=i+1


    for page in range(beginPage, endPage + 1):
        #pn = (page - 1) * 50
        filename = "第" + str(page) + "页.html"
        fullurl = url+"/"+href + "index_" + str(page)+".html"
        #print fullurl
        html = loadPage(fullurl, filename)
        #print html
        dom = etree.HTML(html)
        #a_text = dom.xpath('//div[@id="catalog"]/div/a/@href')
        a_text = dom.xpath('//div[@id="catalog"]/div/a/@href')
        b_text = dom.xpath('//div[@id="catalog"]/div/a/@title')
        i=0
        for ele_book in a_text:
            print(b_text[i])
            bookDownload("https://www.jjxsw.la"+ele_book,pathName+"/"+b_text[i]+".txt","https://www.jjxsw.la")
            i=i+1
        #print(a_text)
        #writePage(html, filename)
        
        #print ('谢谢使用')

#url = "https://whyisee.github.io/"
#word = {"wd":"传智播客"}
#word = urllib.parse.urlencode(word) #转换成url编码格式（字符串）
#newurl = url + "?" + word    # url首个分隔符就是 ?
#
#headers={ "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36"} 
#
#request = urllib.request.Request(newurl, headers=headers) 
#response = urllib.request.urlopen(request) 
#
#print (response.read())

html=loadPage("https://www.jjxsw.la/support/sitemap.html","久久小说")


dom = etree.HTML(html)
#获取 a标签下的文本
#a_text = dom.xpath('/a/text()')
#a_text = dom.xpath('//div/div/div/div/div/a/text()')

a_text = dom.xpath('//div/div/div/div/div/ul/li/a/@href')
#print(dom)

print(a_text)

for ele in a_text:
    print(ele)
    jiujiuSpider("https://www.jjxsw.la",ele,"./")

#jiujiuSpider("https://www.jjxsw.la",a_text[0],"./")
#bookDownload("https://www.jjxsw.la/txt/33753.htm","","https://www.jjxsw.la")
#writePage(html,"久久小说地图.html")