from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.predict.reply import Reply
from learning.tests import helper


class PtnaConversationTestCase(TestCase):

    # TODO setUpClassに変更する(毎回学習処理が走ってしまうため)
    def setUp(self):
        self.csv_file_path = './fixtures/learning_training_messages/ptna.csv'
        self.bot_id = 8  # bot_id = 8 はPTNA
        self.threshold = 0.5
        self.answers = helper.build_answers(self.csv_file_path)

        # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
        # _evaluator = Bot(self.bot_id, helper.learning_parameter()).learn(datasource_type='csv')

    def test_hope_female_teacher(self):
        questions = ['女の先生']
        result = Reply(self.bot_id, helper.learning_parameter()).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = '教室の一覧に性別が表示されていますので、そちらをご参照ください。'

        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)

    def test_hello(self):
        questions = ['こんにちは']
        result = Reply(self.bot_id, helper.learning_parameter()).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = 'こんにちは'

        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)

    def test_want_to_join(self):
        questions = ['入会したいのですが']
        result = Reply(self.bot_id, helper.learning_parameter()).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = 'オンライン入会\r\nhttps://www.piano.or.jp/member_entry/member_entry_step0_1.php\r\n\r\n入会申込書のご請求\r\nhttp://www.piano.or.jp/info/member/memberentry.html'

        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)

    def test_fail_want_to_eat_ramen(self):
        questions = ['おいしいラーメンが食べたいです']
        # questions = ['']
        result = Reply(self.bot_id, helper.learning_parameter()).perform(questions)

        # ラベル0(分類失敗)に分類されること
        eq_(result.answer_id, Reply.CLASSIFY_FAILED_ANSWER_ID)
        ok_(result.probability > self.threshold)

    def test_fail_blank(self):
        questions = ['']
        result = Reply(self.bot_id, helper.learning_parameter()).perform(questions)

        # ラベル0(分類失敗)に分類されること
        eq_(result.answer_id, Reply.CLASSIFY_FAILED_ANSWER_ID)
        ok_(result.probability > self.threshold)
