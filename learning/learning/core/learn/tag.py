import numpy as np
import pandas as pd
import MySQLdb
from learning.log import logger
from learning.core.training_set.training_text import TrainingText
from learning.core.nlang import Nlang
from learning.config.config import Config
from sklearn.externals import joblib
from sklearn.svm import SVC
from sklearn.multiclass import OneVsRestClassifier
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.feature_extraction.text import CountVectorizer
from learning.core.evaluator import Evaluator

class Tag:
    def __init__(self):
        self.config = Config()
        dbconfig = self.config.get('database')
        self.db = MySQLdb.connect(host=dbconfig['host'], db=dbconfig['name'], user=dbconfig['user'], passwd=dbconfig['password'], charset='utf8')

    def learn(self):
        c = OneVsRestClassifier(SVC(kernel='linear', probability=True))
        training_set = TrainingText(self.db)
        training_set.build()

        logger.debug("training_set.x: %s" % training_set.x)
        logger.debug("training_set.y: %s" % training_set.y)

        binarizer = MultiLabelBinarizer().fit(self.__all_tag_ids())
        binarized_y = binarizer.transform(training_set.y)
        logger.debug("binarized_y: %s" % binarized_y)
        logger.debug("binarizer.classes_: %s" % binarizer.classes_)
        estimator = c.fit(training_set.x, binarized_y)

        # HACK pickleでバイナリにしてDBに保存したい(出来ればRails側で)
        joblib.dump(training_set.body_array.vocabulary, "learning/models/%s/tag_vocabulary.pkl" % self.config.env)
        joblib.dump(estimator, "learning/models/%s/tag_model" % self.config.env)
        joblib.dump(binarizer, "learning/models/%s/tag_model_labels.pkl" % self.config.env)

        evaluator = Evaluator()
        evaluator.evaluate(estimator, training_set.x, binarized_y)

    def __all_tag_ids(self):
        result = pd.read_sql('select id from tags', self.db)
        ids = np.array(result['id'])
        ids = ids.astype(str)
        ids = np.append(ids, '0')
        ids = np.append(ids, ',')
        logger.debug("ids: %s" % ids)
        return [ids]
