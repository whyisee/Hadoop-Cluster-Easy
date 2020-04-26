import scrapy
from scrapy.spiders import CrawlSpider
from scrapy.selector import Selector
from scrapy.http import Request
from HelloScrapy.items import HelloscrapyItem
import urllib

class Jianshu(CrawlSpider):
    name="HelloScrapy"
    start_urls=['https://www.jianshu.com']
    url='https://www.jianshu.com'

    def parse(self,response):
        selector = Selector(response)
        #print(selector)
        articles = selector.xpath('//ul[@class="note-list"]/li')
        item=HelloscrapyItem()

        for article in articles:
            print(article)
            title=article.xpath('div[@class="content"]/a/text()').extract()
            print(title)
            item['title'] = title

            #url = article.xpath('div/h4/a/@href').extract()
            #author = article.xpath('div/p/a/text()').extract()
            try:
                image = article.xpath("a/img/@src").extract()
                urllib.urlretrieve(image[0], '/Users/apple/Documents/images/%s-%s.jpg' %(author[0],title[0]))
            except:
                print('--no---image--')
            #listtop = article.xpath('div/div/a/text()').extract()
            #likeNum = article.xpath('div/div/span/text()').extract()

            #readAndComment = article.xpath('div/div[@class="list-footer"]')
            #data = readAndComment[0].xpath('string(.)').extract()[0]


            #item['url'] = 'http://www.jianshu.com/'+url[0]
            #item['author'] = author

            #item['readNum']=listtop[0]
            # 有的文章是禁用了评论的
            try:
                item['commentNum']=listtop[1]
            except:
                item['commentNum']=''
            #item['likeNum']= likeNum
            yield item
            print (item)

        next_link = selector.xpath('//div[@class="guide-pager"]/a/@href').extract()
        #next_url=next_link[1].xpath('a/@href').extract()
        #article.xpath('div/h4/a/@href').extract()
        #print(next_link[1])
        #print(next_link[0])

        #print(len(next_link))
        #print(next_url)
        #yield Request('https://whyisee.github.io/'+next_link[1],callback=self.parse)
        if len(next_link)==1 :
            next_link = self.url+ str(next_link[0])
            print("----"+next_link)
            #yield Request(next_link,callback=self.parse)