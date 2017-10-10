import os.path
import inject
from gensim.models import LsiModel
from app.shared.current_bot import CurrentBot
from app.shared.datasource.datasource import Datasource


# HACK: gensim_tfidf_vectorizerを使ったデータ以外だとうまく動かない
class GensimLSI:
    @inject.params(bot=CurrentBot, datasource=Datasource)
    def __init__(self, bot=None, datasource=None):
        self.bot = bot
        self.reducer_path = './prototype/working/myope_lsi_1000.model'
        if os.path.isfile(self.reducer_path):
            self.reducer = LsiModel.load(self.reducer_path)
        else:
            self.reducer = LsiModel.load('./prototype/working/lsi_1000.model')

    def fit(self, features):
        # lsi = LsiModel(corpus=tfidf_corpus, id2word=dictionary, num_topics=1000)
        # lsi.save(self.reducer_path)
        # self.reducer.add_documents(features, chunksize=100, decay=0.8)
        # self.reducer.save(self.reducer_path)
        pass

    def transform(self, features):
        return self.reducer[features]

    def fit_transform(self, features):
        self.fit(features)
        return self.transform(features)

    @property
    def dump_key(self):
        return 'dump_lsi'
