from learning.log import logger
from sklearn.externals import joblib
from learning.config.config import Config

class Persistance:

    @classmethod
    def dump_model(self, estimator, bot_id):
        joblib.dump(estimator, self.get_model_path(bot_id))

    @classmethod
    def load_model(self, bot_id):
        return joblib.load(self.get_model_path(bot_id))

    @classmethod
    def get_model_path(self, bot_id):
        config = Config()
        # TODO ロジスティック回帰とは限らない
        return "learning/models/%s/%s_logistic_reg_model" % (config.env, bot_id)
