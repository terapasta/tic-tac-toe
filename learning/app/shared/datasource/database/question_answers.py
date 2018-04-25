import pandas as pd
from app.shared.datasource.database.database import Database
from app.shared.base_cls import BaseCls


# Note: learning_trining_messagesテーブルを使いquestionとanswerを取得する
#       結果dataframeにquestion_answer_id, question の2つのカラムが必要
#       (他のテーブルを使う場合はカラム名を別名にするなどして上記を用意すること)
class QuestionAnswers(BaseCls):
    def __init__(self):
        self.database = Database()

    def all(self):
        question_answers = self.database.select(
            "select * from question_answers;",
            params={}
        )
        sub_questions = self.database.select(
            "select * from sub_questions;",
            params={}
        )
        return self.__make_data(question_answers, sub_questions)

    def by_bot(self, bot_id):
        question_answers = self.database.select(
            "select * from question_answers where bot_id = %(bot_id)s;",
            params={"bot_id": bot_id}
        )
        sub_questions = self.database.select(
            "select * from sub_questions where question_answer_id in (select question_answers.id from question_answers where question_answers.bot_id = %(bot_id)s);",
            params={"bot_id": bot_id}
        )
        return self.__make_data(question_answers, sub_questions)


    def __make_data(self, question_answers, sub_questions):
        data1 = pd.DataFrame({
            'question_answer_id': question_answers['id'],
            'question': question_answers['question_wakati']
        })
        data2 = pd.DataFrame({
            'question_answer_id': sub_questions['question_answer_id'],
            'question': sub_questions['question_wakati']
        })
        result = pd.concat([data1, data2])
        return result
