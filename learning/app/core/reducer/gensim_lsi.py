import inject
from gensim.models import LsiModel
from app.shared.logger import logger
from app.shared.current_bot import CurrentBot
from app.shared.datasource.datasource import Datasource


# HACK: gensim_tfidf_vectorizerを使ったデータ以外だとうまく動かない
class GensimLSI:
    @inject.params(bot=CurrentBot, datasource=Datasource)
    def __init__(self, bot=None, datasource=None):
        self.bot = bot
        self.reducer = LsiModel.load('../../../prototype/working/lsi_1000.model')

    def fit(self, features):
        # Note: オンライン学習機能は未実装
        logger.info('PASS')

    def transform(self, features):
        return self.reducer[features]

    def fit_transform(self, features):
        self.fit(features)
        return self.transform(features)

    @property
    def dump_key(self):
        return 'dump_lsi'
