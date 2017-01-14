from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.bot import Bot
from learning.core.learn.learning_parameter import LearningParameter
from learning.core.predict.reply import Reply
from learning.tests import helper


class DaikinConversationTestCase(TestCase):

    def setUp(self):
        self.csv_file_path = 'learning/tests/engine/fixtures/test_daikin_conversation.csv'
        self.bot_id = 998  # テスト用のbot_id いずれの値でも動作する
        self.threshold = 0.5
        self.answers = helper.build_answers(self.csv_file_path, encoding='SHIFT-JIS')  # TODO セプテーニの方もhelperを使うように修正
        self.learning_parameter = LearningParameter({
            'include_failed_data': False,
            'include_tag_vector': False,
            'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
            'params_for_algorithm': {'C': 200}
        })

        # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
        _evaluator = Bot(self.bot_id, self.learning_parameter).learn(csv_file_path=self.csv_file_path)

    def test_how_to_add_mail_signature(self):
        questions = ['メールに署名を付ける方法を知りたい']
        results = Reply(self.bot_id, self.learning_parameter).predict(questions)
        answer_id = results[0]['answer_id']
        probability = results[0]['probability']
        answer_body = helper.get_answer_body(self.answers, answer_id)

        expected_answer = """署名の作り方については『【Outlook2010操作マニュアル 応用編】 署名の作成』を参照してください。
http://www.intra.daikin.co.jp/office365/ol2010/Applied.html?cid=C008

【手順】
１．リボンから『ファイル』を選択し、『オプション』を押下します。
２．『メール』を押下します
３．『署名』ボタンを押下します。
４．『新規作成』ボタンを押下します。
５．署名の名前を入力します。（分かりやすい名前をつけてください。）
６．『OK』ボタンを押下します。
７．作成した署名を選択します。（既に作成されている場合は、編集したい署名を選択)
８．署名の内容を入力します。
９．新しいメッセージを作成する際に挿入される署名を選択します。
１０．返信/転送を行う際に挿入される署名を選択します。
１１．『OK』ボタンを押下します。
"""
        eq_(helper.replace_newline(answer_body), helper.replace_newline(expected_answer))
        ok_(probability > self.threshold)


