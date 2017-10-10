import inject
import os.path
from gensim.corpora import Dictionary
from gensim.models import LsiModel
from app.shared.current_bot import CurrentBot
from app.shared.datasource.datasource import Datasource


# HACK: gensim_tfidf_vectorizerを使ったデータ以外だとうまく動かない
class GensimLSI:
    @inject.params(bot=CurrentBot, datasource=Datasource)
    def __init__(self, bot=None, datasource=None):
        self.bot = bot
        self.reducer_path = './prototype/working/myope_lsi.model'
        if os.path.isfile(self.reducer_path):
            self.reducer = LsiModel.load(self.reducer_path)

    def fit(self, features):
        dictionary = Dictionary.load_from_text('./prototype/working/myope_wordids.txt.bz2')
        self.reducer = LsiModel(corpus=features, id2word=dictionary, num_topics=len(features))
        self.reducer.save(self.reducer_path)

    def transform(self, features):
        return self.reducer[features]

    def fit_transform(self, features):
        self.fit(features)
        return self.transform(features)

    @property
    def dump_key(self):
        return 'dump_lsi'
