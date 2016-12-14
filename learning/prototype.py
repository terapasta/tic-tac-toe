import pandas as pd
import MeCab
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.naive_bayes import MultinomialNB
from sklearn.naive_bayes import GaussianNB
from sklearn.naive_bayes import BernoulliNB
from learning.core.nlang import Nlang

def splited_data(data):
    splited_data = []
    for datum in data:
        splited_data.append(split(datum))
    return splited_data

def split(text):
    tagger = MeCab.Tagger("-u learning/dict/custom.dic")
    tagger.parse('')  # node.surfaceを取得出来るようにするため、空文字をparseする(Python3のバグの模様)
    node = tagger.parseToNode(text)
    word_list = []
    while node:
        features = node.feature.split(",")
        pos = features[0]
        # logger.debug("node.feature: %s" % node.feature)
        # if pos in ["名詞", "動詞", "形容詞", "感動詞", "助動詞", "副詞"]:
        if pos in ["名詞", "動詞", "形容詞", "感動詞", "副詞"]:
            if pos == '名詞' and features[1] == '非自立':
                node = node.next
                continue
            if pos == '動詞' and features[1] == '非自立':
                node = node.next
                continue
            lemma = node.feature.split(",")[6]  #.decode("utf-8")
            if lemma == 'ある':
                node = node.next
                continue

            if lemma == "*":
                lemma = node.surface  #.decode("utf-8")

            # word_list.append(conv.do(jaconv.kata2hira(lemma)))
            # word_list.append(jaconv.kata2hira(lemma))
            word_list.append(lemma)
        node = node.next
    return " ".join(word_list)


data = pd.read_csv('prototype.csv', encoding='SHIFT-JIS')
questions = splited_data(data['question'])
answers = data['answer']

vectorizer = CountVectorizer()
vec = vectorizer.fit_transform(questions)

print(vectorizer.get_feature_names())
print(vec.toarray())

transformer = TfidfTransformer()
tfidf = transformer.fit_transform(vec)
print(tfidf.toarray())

clf = MultinomialNB()
clf.fit(tfidf, answers)

########## pridict ##############
# X = split('My-opeってなんですか？')
X = split('セキュリティはどうなってる？')
X = vectorizer.transform([X])
X = transformer.transform(X)
print(X.toarray())
result = clf.predict_proba(X)
print(result)
