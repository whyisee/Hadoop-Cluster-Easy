#!/usr/bin/env python

from sklearn.feature_extraction import DictVectorizer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
import jieba

def dict_demo():
    data = [{'city':'北京','temperature':100}
    ,{'city':'深圳','temperature':30}
    ,{'city':'上海','temperature':60}]

    #1.实例化一个转换器
    transfer = DictVectorizer(sparse=False)

    #2.调用fit_transform
    result = transfer.fit_transform(data)

    #
    print("返回结果:\n",result)
    print("特征名字:\n",transfer.get_feature_names())

def text_count_demo():
    data = ["life is short ,i like like python"
    ,"life is too long ,i dislike python"]
    
    transtor = CountVectorizer()
    result = transtor.fit_transform(data)

    print("文本特征结果:\n",result.toarray())
    print("返回特征名字:\n",transtor.get_feature_names())

def cut_word(text):
    text = " ".join(list(jieba.cut(text)))

    return text

def text_chinese_count_demo2():
    data = ["一种还是一种今天很残酷，明天更残酷，后天很美好，但绝对大部分是死在明天晚上，所以每个人不要放弃今天。"
    ,"我们看到的从很远星系来的光是在几百万年之前发出的，这样当我们看到宇宙时，我们是在看它的过去。"
    ,"如果只用一种方式了解某样事物，你就不会真正了解它。了解事物真正含义的秘密取决于如何将其与我们所了解的事物相联系。"]

    text_list = []

    for sent in data:
        text_list.append(cut_word(sent))
    
    print(text_list)

    transfer = CountVectorizer()
    result = transfer.fit_transform(text_list)

    print("文本特征结果:\n",result.toarray())
    print("返回特征名字:\n",transfer.get_feature_names())

def text_chinese_tfidf_demo():
    data = ["一种还是一种今天很残酷，明天更残酷，后天很美好，但绝对大部分是死在明天晚上，所以每个人不要放弃今天。"
    ,"我们看到的从很远星系来的光是在几百万年之前发出的，这样当我们看到宇宙时，我们是在看它的过去。"
    ,"如果只用一种方式了解某样事物，你就不会真正了解它。了解事物真正含义的秘密取决于如何将其与我们所了解的事物相联系。"]

    text_list = []

    for sent in data:
        text_list.append(cut_word(sent))
    
    print(text_list)

    transfer = TfidfVectorizer(stop_words=['一种','不会','不要'])
    result = transfer.fit_transform(text_list)

    print("文本特征结果:\n",result.toarray())
    print("返回特征名字:\n",transfer.get_feature_names())
#
#dict_demo()
#text_count_demo()
#text_chinese_count_demo2()
text_chinese_tfidf_demo()
