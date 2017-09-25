import inject
import io
from sklearn.externals import joblib
from app.shared.current_bot import CurrentBot
from app.shared.datasource.database.database import Database


class Persistence:
    @inject.params(database=Database, bot=CurrentBot)
    def __init__(self, database=None, bot=None):
        self.database = database
        self.bot = bot

    def load(self, name):
        records = self.database.select(
            'SELECT * FROM dumps WHERE bot_id = %(bot_id)s AND name = %(name)s;',
            {
                'bot_id': self.bot.id,
                'name': name,
            },
        )
        if len(records) > 0 and records['content'][0] is not None:
            file = io.BytesIO(records['content'][0])
            return joblib.load(file)

        return None

    def dump(self, obj, name):
        file = io.BytesIO()
        joblib.dump(obj, file)
        file.seek(0)
        self.database.execute_with_transaction(
                [
                    [
                        'DELETE FROM dumps WHERE bot_id = %(bot_id)s AND name = %(name)s;',
                        {
                            'bot_id': self.bot.id,
                            'name': name,
                        },
                    ],
                    [
                        'INSERT INTO dumps (bot_id, name, content) VALUES (%(bot_id)s, %(name)s, %(content)s);',
                        {
                            'bot_id': self.bot.id,
                            'name': name,
                            'content': file.getvalue(),
                        },
                    ],
                ],
            )
