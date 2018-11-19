import numpy as np
import pandas as pd

from app.shared.logger import logger
from app.shared.constants import Constants
from app.shared.base_cls import BaseCls
from app.core.pipe.learn_pipe import LearnPipe
from app.core.pipe.reply_pipe import ReplyPipe

class LearnController(BaseCls):
    def __init__(self, context):
        self.bot = context.current_bot
        self.factory = context.get_factory()
        self.learn_pipe = LearnPipe(self.factory)
        self.reply_pipe = ReplyPipe(self.factory)

    def perform(self):
        logger.info('start')
        logger.debug('bot_id: %s' % self.bot.id)

        # HACK: 各種fitをするために_learn_for_vocablaryを必ず最初に実行しないといけない
        self._learn_for_vocabulary()

        self._learn_bot()

        result = self._evaluate()

        logger.info('end')

        return result

    def _learn_for_vocabulary(self):
        logger.info('load all get_datasource')
        question_answers = self.factory.get_datasource().question_answers.all()
        ratings = self.factory.get_datasource().ratings.all()
        all_questions = pd.concat([question_answers['question'], ratings['question']]).dropna()

        # 学習用の Pipe で一括処理
        self.learn_pipe.perform(all_questions)

    def _learn_bot(self):
        logger.info('load question_answers and ratings')
        bot_qa_data = self.factory.get_datasource().question_answers.by_bot(self.bot.id)
        bot_ratings_data = self.factory.get_datasource().ratings.with_good_by_bot(self.bot.id)

        all_questions = np.array(pd.concat([bot_qa_data['question'], bot_ratings_data['question']]).dropna())
        all_answer_ids = np.array(pd.concat([bot_qa_data['question_answer_id'], bot_ratings_data['question_answer_id']]), dtype=np.int)

        # Note: 空のテキストにラベル0を対応付けるために強制的にトレーニングセットを追加
        all_questions = np.append(all_questions, [''] * Constants.COUNT_OF_APPEND_BLANK)
        all_answer_ids = np.append(all_answer_ids, [Constants.CLASSIFY_FAILED_ANSWER_ID] * Constants.COUNT_OF_APPEND_BLANK)

        # 各質問応答の学習時には応答用の Pipe を用いる
        # 学習用のパイプは基本的に fit しかせず、transform していないので、
        # データが失われてしまう
        bot_features = self.reply_pipe.perform(all_questions)

        logger.info('fit')
        self.factory.core.fit(
                bot_features,
                all_answer_ids,
                all_questions,
            )

    def _evaluate(self):
        #
        # IMPORTANT:
        # protocol buffer を使用して gRPC でデータのやり取りをするので、
        # app/learning/gateway.proto も更新する
        #
        # see: https://github.com/mofmof/donusagi-bot/wiki/Python側の開発に関わる情報
        #
        return {
            'accuracy': 0,
            'precision': 0,
            'recall': 0,
            'f1': 0,
            'meta': self._learning_meta_data(),
        }

    def _learning_meta_data(self):
        return self.bot.learning_meta_data()
