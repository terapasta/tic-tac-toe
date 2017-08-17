from app.shared.datasource.database.database import Database


class LearningTrainingMessages:
    def __init__(self):
        self.database = Database()

    def by_bot(self, bot_id):
        return self.database.select(
                "select * from learning_training_messages where bot_id = %(bot_id)s;",
                params={"bot_id": bot_id}
            )
