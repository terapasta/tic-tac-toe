from app.shared.datasource.database.database import Database
from app.shared.constants import Constants


class Ratings:
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

    def higher_rate_by_bot_question(self, bot_id, question):
        # Note: データ件数が増えたときにパフォーマンスが低い可能性がある
        return self.database.select(
                """
                select
                    question,
                    level,
                    question_answer_id,
                    count(*) as count
                from ratings
                where
                    bot_id = %(bot_id)s
                    and question = %(question)s
                    and question_answer_id != 0
                group by level
                order by count desc;
                """,
                params={"bot_id": bot_id, "question": question},
            )
