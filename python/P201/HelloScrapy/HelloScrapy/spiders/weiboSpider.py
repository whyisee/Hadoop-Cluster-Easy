import scrapy
from scrapy.spiders import CrawlSpider
from scrapy.selector import Selector
from scrapy.utils.response import open_in_browser
from scrapy.shell import inspect_response


class Weibo(CrawlSpider):
    name="Weibo"
    start_urls=["https://weibo.com"]

    
    def parse(self, response):
        selector = Selector(response)
        articles = selector.xpath('//ul[@class="pt_ul clearfix"]/div')
        print(selector)
        print(articles)
        inspect_response(response, self)
        open_in_browser(response)
            


