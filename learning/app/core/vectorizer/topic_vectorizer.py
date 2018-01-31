from injector import inject
import numpy as np
import scipy.sparse as sp
from sklearn.exceptions import NotFittedError
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import CountVectorizer
from app.shared.datasource.datasource import Datasource
from app.shared.custom_errors import NotTrainedError
from app.core.vectorizer.base_vectorizer import BaseVectorizer


class TopicVectorizer(BaseVectorizer):
    @inject
    def __init__(self, datasource: Datasource, dump_key='topic_vectorizer'):
        self.persistence = datasource.persistence
        self._dump_key = dump_key

        # ベクタライザの集合
        self.vectorizers = None
        # 主題の特徴量
        self.subject_vectorizer = None
        # 述語の特徴量
        self.predicate_vectorizer = None
        # 全文の特徴量
        self.raw_data_vectorizer = None

    def fit(self, sentences_with_pos):
        self._prepare_instance_if_needed()

        sentences_for_subject, sentences_for_predicate, sentences_for_raw_data = \
            self._split_sentences(sentences_with_pos)

        # train for subject
        self.subject_vectorizer.fit(sentences_for_subject)

        # train for predicate
        self.predicate_vectorizer.fit(sentences_for_predicate)

        # train for raw data
        self.raw_data_vectorizer.fit(sentences_for_raw_data)

        self.persistence.dump(self.vectorizers, self.dump_key)

    def transform(self, sentences_with_pos):
        self._prepare_instance_if_needed()
        try:
            sentences_for_subject, sentences_for_predicate, sentences_for_raw_data = \
                self._split_sentences(sentences_with_pos)

            # 各特徴量毎に特徴ベクトルに変換
            fv_subject = self.subject_vectorizer.transform(sentences_for_subject)
            fv_predicate = self.predicate_vectorizer.transform(sentences_for_predicate)
            fv_raw_data = self.raw_data_vectorizer.transform(sentences_for_raw_data)

            # 各特徴ベクトルの結合
            fv = sp.hstack((fv_subject, fv_predicate, fv_raw_data))

            return fv
        except NotFittedError as e:
            raise NotTrainedError(e)

    def fit_transform(self, sentences_with_pos):
        self.fit(sentences_with_pos)
        return self.transform(sentences_with_pos)

    def extract_feature_count(self, sentences):
        return np.count_nonzero(self.transform(sentences).toarray())

    @property
    def dump_key(self):
        return self._dump_key

    def _prepare_instance_if_needed(self):
        # 学習済みのベクタライザがあればそれをロード
        if self.vectorizers is None:
            vectorizers = self.persistence.load(self.dump_key)
            if not vectorizers is None and isinstance(vectorizers, dict):
                self.subject_vectorizer = vectorizers['subject']
                self.predicate_vectorizer = vectorizers['predicate']
                self.raw_data_vectorizer = vectorizers['raw_data']
                self.vectorizers = vectorizers

        # 学習済みのものがなければ新規作成
        if self.vectorizers is None:
            # NOTE: 主題と述語には n-gramベクタライザを使用
            self.subject_vectorizer = CountVectorizer(analyzer='char_wb', ngram_range=(2, 3))
            self.predicate_vectorizer = CountVectorizer(analyzer='char_wb', ngram_range=(2, 3))

            # NOTE: 全文では TF-IDFベクタライザを使用
            #       token_patternは1文字のデータを除外しない設定
            self.raw_data_vectorizer = TfidfVectorizer(use_idf=True, token_pattern=u'(?u)\\b\\w+\\b')

            self.vectorizers = {
                "subject": self.subject_vectorizer,
                "predicate": self.predicate_vectorizer,
                "raw_data": self.raw_data_vectorizer,
            }

    def _split_sentences(self, sentences_with_pos):
        words_for_subject = []
        words_for_predicate = []
        words_for_raw_data = []

        for words_with_pos in sentences_with_pos:
            wfs = []
            wfp = []
            wfr = []
            for wp in words_with_pos:
                if wp['pos'] == '名詞':
                    wfs.append(wp['word'])
                elif wp['pos'] == '動詞':
                    wfp.append(wp['word'])
                wfr.append(wp['word'])

            words_for_subject.append(','.join(wfs))
            words_for_predicate.append(','.join(wfp))
            words_for_raw_data.append(','.join(wfr))

        return (words_for_subject, words_for_predicate, words_for_raw_data)