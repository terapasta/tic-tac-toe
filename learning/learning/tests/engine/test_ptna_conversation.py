from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.predict.reply import Reply
from learning.tests import helper


class PtnaConversationTestCase(TestCase):
    csv_file_path = 'learning/tests/fixtures/test_ptna_conversation.csv'
    external_vocabulary_csv_file_path = 'learning/tests/fixtures/test_external_vocabulary.csv'
    bot_id = 996  # テスト用のbot_id いずれの値でも動作する
    threshold = 0.5

    @classmethod
    def setUpClass(cls):
        cls.answers = helper.build_answers(cls.csv_file_path)
        cls.learning_parameter = helper.learning_parameter()
        # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
        _evaluator = Bot(cls.bot_id, cls.learning_parameter).learn(
            csv_file_path=cls.csv_file_path, 
            external_vocabulary_csv_file_path=cls.external_vocabulary_csv_file_path
        )


    def test_hope_female_teacher(self):
        questions = ['女の先生']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = '教室の一覧に性別が表示されていますので、そちらをご参照ください。'

        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)

    def test_hello(self):
        questions = ['こんにちは']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = 'こんにちは'

        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)

    def test_want_to_join(self):
        questions = ['入会したいのですが']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = 'オンライン入会\r\nhttps://www.piano.or.jp/member_entry/member_entry_step0_1.php\r\n\r\n入会申込書のご請求\r\nhttp://www.piano.or.jp/info/member/memberentry.html'

        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)

    def test_fail_want_to_eat_ramen(self):
        questions = ['おいしいラーメンが食べたいです']
        # questions = ['']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)

        # ラベル0(分類失敗)に分類されること
        eq_(result.answer_id, Reply.CLASSIFY_FAILED_ANSWER_ID)
        ok_(result.probability > self.threshold)

    def test_fail_blank(self):
        questions = ['']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)

        # ラベル0(分類失敗)に分類されること
        eq_(result.answer_id, Reply.CLASSIFY_FAILED_ANSWER_ID)
        ok_(result.probability > self.threshold)
