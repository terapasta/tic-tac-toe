import inject
import os.path
import itertools
from gensim.corpora import Dictionary, MmCorpus
from gensim.models import TfidfModel
from app.shared.current_bot import CurrentBot
from app.shared.datasource.datasource import Datasource


# Note: wikipediaのデータを使って作ったTfidfモデルを利用できるvectorizer
# Hack: インタフェースが合っておらず、gensim以外の後処理に使えない
class GensimTfidfVectorizer:
    @inject.params(bot=CurrentBot, datasource=Datasource)
    def __init__(self, bot=None, datasource=None):
        self.bot = bot
        # TODO: 検証用ファイルを参照しているので、S3などに配置してそこから取得するように変える
        self.text_path = './prototype/working/myope_wordids.txt.bz2'
        self.tfidf_path = './prototype/working/myope.tfidf_model'
        if not os.path.isfile(self.text_path):
            self.dictionary = Dictionary.load_from_text('./prototype/working/wiki_wordids.txt.bz2')
        else:
            self.dictionary = Dictionary.load_from_text(self.text_path)

        if not os.path.isfile(self.tfidf_path):
            self.vectorizer = TfidfModel.load('./prototype/working/wiki.tfidf_model')
        else:
            self.vectorizer = TfidfModel.load(self.tfidf_path)

    def fit(self, sentences):
        pass
        # self.dictionary.add_documents([sentence.split(' ') for sentence in sentences])
        # self.dictionary.save_as_text(self.text_path)
        # corpus = [self.dictionary.doc2bow(text, allow_update=True) for text in [sentence.split(' ') for sentence in sentences]]
        # MmCorpus.serialize('./prototype/working/myope.mm', corpus, id2word=self.dictionary)
        # mm = MmCorpus('./prototype/working/myope.mm')
        # wiki_mm = MmCorpus('./prototype/working/wiki_bow.mm')
        # # Note: Macbook core i5 メモリ8GBで2時間半くらいかかる
        # self.vectorizer = TfidfModel(itertools.chain(wiki_mm, mm), id2word=self.dictionary, normalize=True)
        # self.vectorizer.save(self.tfidf_path)

    def transform(self, sentences):
        id_corpus = [self.dictionary.doc2bow(sentence.split(' ')) for sentence in sentences]
        return self.vectorizer[id_corpus]

    def fit_transform(self, sentences):
        self.fit(sentences)
        return self.transform(sentences)

    @property
    def dump_key(self):
        return 'none'
