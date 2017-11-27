from app.shared.datasource.database.database import Database
from app.shared.constants import Constants
from app.shared.base_cls import BaseCls


class Ratings(BaseCls):
    def __init__(self):
        self.database = Database()

    def all(self):
        return self.database.select(
                "select * from ratings;",
                params={},
            )

    def by_bot(self, bot_id):
        return self.database.select(
                "select * from ratings where bot_id = %(bot_id)s;",
                params={"bot_id": bot_id},
            )

    def with_good_by_bot(self, bot_id):
        return self.database.select(
                "select * from ratings where bot_id = %(bot_id)s and level = %(level)s;",
                params={"bot_id": bot_id, "level": Constants.RATING_GOOD},
            )

    def with_bad_by_bot(self, bot_id):
        return self.database.select(
                "select * from ratings where bot_id = %(bot_id)s and level = %(level)s;",
                params={"bot_id": bot_id, "level": Constants.RATING_BAD},
            )

    def higher_rate_by_bot_question(self, bot_id, question):
        # Note: 以下のratingsを取得する
        #     - 存在するquestion_answer_idを持っている
        #     - 解答失敗を除く(question_answer_idが0でない
        #     - 同じquestion内でgood/badそれぞれ件数を出し多い方を優先する
        # Note: データ件数が増えたときにパフォーマンスが低い可能性がある
        return self.database.select(
                """
                select
                    ratings.question as question,
                    ratings.level as level,
                    ratings.question_answer_id as question_answer_id,
                    count(*) as count
                from ratings
                    left join question_answers
                    on ratings.question_answer_id = question_answers.id
                where
                    ratings.bot_id = %(bot_id)s
                    and ratings.question = %(question)s
                    and ratings.question_answer_id != 0
                    and question_answers.id is not null
                group by level
                order by count desc;
                """,
                params={"bot_id": bot_id, "question": question},
            )
