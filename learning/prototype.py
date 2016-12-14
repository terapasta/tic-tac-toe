import pandas as pd
import MeCab
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfVectorizer
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

def learn_multinomial_nb(data, vectorizer):
    questions = splited_data(data['question'])
    answers = data['answer']

    vec = vectorizer.transform(questions)
    # print(vectorizer.get_feature_names())
    # print(vec.toarray())

    # transformer = TfidfTransformer()
    # tfidf = transformer.fit_transform(vec)
    # print(tfidf.toarray())

    clf = MultinomialNB()
    clf.fit(vec, answers)
    return clf

def build_count_vectorizer(data):
    questions = splited_data(data['question'])
    vectorizer = CountVectorizer()
    vectorizer.fit(questions)
    return vectorizer

def build_tfidf_vectorizer(data):
    questions = splited_data(data['question'])
    vectorizer = TfidfVectorizer()
    vectorizer.fit(questions)
    return vectorizer

def predict(clf, X, vectorizer):
    features = vectorizer.transform(X)
    answers = clf.predict(features)
    proba = clf.predict_proba(features)

    for (question, answer, probabilities) in zip(X, answers, proba):
        print('question: %s' % question)
        print('answer: %s' % answer)
        print('proba: %s \n' % max(probabilities))


data = pd.read_csv('prototype.csv', encoding='SHIFT-JIS')
X = [
    split('セキュリティはどうなってる？'),
    split('データ投入はどうやるの？'),
    split('ほげほげ'),
]

print('########## CountVectorizer + MultinomialNB ##############')
count_vectorizer = build_count_vectorizer(data)
clf = learn_multinomial_nb(data, count_vectorizer)
predict(clf, X, count_vectorizer)

print('########## TfidfVectorizer + MultinomialNB ##############')
tfidf_vectorizer = build_tfidf_vectorizer(data)
clf = learn_multinomial_nb(data, tfidf_vectorizer)
predict(clf, X, tfidf_vectorizer)
