from app.shared.datasource.database.database import Database


# Note: learning_trining_messagesテーブルを使いquestionとanswerを取得する
#       結果dataframeにquestion_id, question の2つのカラムが必要
#       (他のテーブルを使う場合はカラム名を別名にするなどして上記を用意すること)
class QuestionAnswers:
    def __init__(self):
        self.database = Database()

    def all(self):
        return self.database.select(
                "select * from learning_training_messages;",
                params={}
            )

    def by_bot(self, bot_id):
        return self.database.select(
                "select * from learning_training_messages where bot_id = %(bot_id)s;",
                params={"bot_id": bot_id}
            )
