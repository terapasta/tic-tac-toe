from app.shared.datasource.database.database import Database


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
