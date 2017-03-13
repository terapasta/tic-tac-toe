from unittest import TestCase
from nose.tools import ok_, eq_

from learning.core.learn.learning_parameter import LearningParameter
from learning.core.predict.reply import Reply
from learning.tests import helper


class DaikinConversationTestCase(TestCase):
    csv_file_path = 'learning/tests/engine/fixtures/test_daikin_conversation.csv'
    bot_id = 998  # テスト用のbot_id いずれの値でも動作する
    threshold = 0.5
    learning_parameter = LearningParameter({
        'include_failed_data': False,
        'include_tag_vector': False,
        'algorithm': LearningParameter.ALGORITHM_LOGISTIC_REGRESSION,
        'params_for_algorithm': {'C': 200}
    })


    @classmethod
    def setUpClass(cls):
        cls.answers = helper.build_answers(cls.csv_file_path)
        # 学習処理は時間がかかるためmodelのdumpファイルを作ったらコメントアウトしてもテスト実行可能
        # _evaluator = Bot(cls.bot_id, cls.learning_parameter).learn(csv_file_path=cls.csv_file_path)

    def test_how_to_add_mail_signature(self):
        questions = ['メールに署名を付ける方法を知りたい']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

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
        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)


    def test_how_much_limit_file_size_attached_mail(self):
        questions = ['社外からのメール添付ファイルの受信容量制限は？']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = """ダイキン社内間であれば、メール送受信の容量制限は10MBになります。
メール本文も含めた容量になります。
社外からダイキンメールに添付ファイルを送付された場合ですが、社外のメールサーバの容量制限によって送受信できない場合があります。その際は社外の方へ確認を依頼ください。"""
        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)


    def test_spam_mail_in_folder(self):
        questions = ['SPAMフォルダにメールが入っている']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)
        answer_body = helper.get_answer_body(self.answers, result.answer_id)

        expected_answer = """迷惑メールフィルタの性質上、そのようなことがあります。
自動削除される前に別フォルダに移動してください。"""
        eq_(helper.replace_newline_and_space(answer_body), helper.replace_newline_and_space(expected_answer))
        ok_(result.probability > self.threshold)


    def test_dislike_shiitake(self):
        questions = ['しいたけは嫌いな食べ物です']
        result = Reply(self.bot_id, self.learning_parameter).perform(questions)

        # しきい値を超える回答がないこと
        ok_(result.probability < self.threshold)


