from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.predict.reply import Reply
from learning.tests import helper


class PtnaConversationTestCase(TestCase):

    def setUp(self):
        self.csv_file_path = 'learning/tests/engine/fixtures/test_ptna_conversation.csv'
        self.bot_id = 996  # テスト用のbot_id いずれの値でも動作する
        self.threshold = 0.5
        self.answers = helper.build_answers(self.csv_file_path)

        # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
        _evaluator = Bot(self.bot_id, helper.learning_parameter()).learn(csv_file_path=self.csv_file_path)

    def test_hope_female_teacher(self):
        questions = ['女の先生']
        result = Reply(self.bot_id, helper.learning_parameter()).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = '教室の一覧に性別が表示されていますので、そちらをご参照ください。'

        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)

