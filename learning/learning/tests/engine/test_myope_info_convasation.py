from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.predict.reply import Reply


class MyopeInfoConvasationTestCase(TestCase):
    learning_parameter = LearningParameter({
        'include_failed_data': False,
        'include_tag_vector': False,
        'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION
    })

    def setUp(self):
        bot_id = 5  # dummy
        evaluator = Bot(bot_id, self.learning_parameter).learn(csv_file_path='learning/tests/engine/fixtures/test_myope_info_convasation.csv')

    def test_how_is_security(self):
        threshold = 0.62
        questions = ['セキュリティはどう？']
        bot_id = 5  # dummy
        results = Reply(bot_id, self.learning_parameter).predict(questions)
        print(results)

        # 回答が'セキュリティ対策については、ファイアウォールやSSL接続などの一般的な対策は行っております。'になること
        eq_(results[0]['answer_id'], 3692)  # TODO idベタ打ちではなくデータ定義から取得するように変更する
        # ok_(results[0]['probability'] > threshold)  # TODO
