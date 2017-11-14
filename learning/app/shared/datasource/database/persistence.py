import inject
import io
from sklearn.externals import joblib
from app.shared.datasource.database.database import Database


class Persistence:
    @inject.params(database=Database)
    def __init__(self, database=None):
        self.database = database

    def load(self, bot_id, name):
        records = self.database.select(
            'SELECT * FROM dumps WHERE bot_id = %(bot_id)s AND name = %(name)s;',
            {
                'bot_id': bot_id,
                'name': name,
            },
        )
        if len(records) > 0 and records['content'][0] is not None:
            file = io.BytesIO(records['content'][0])
            return joblib.load(file)

        return None

    def dump(self, obj, bot_id, name):
        file = io.BytesIO()
        joblib.dump(obj, file)
        file.seek(0)
        self.database.execute_with_transaction(
                [
                    [
                        'DELETE FROM dumps WHERE bot_id = %(bot_id)s AND name = %(name)s;',
                        {
                            'bot_id': bot_id,
                            'name': name,
                        },
                    ],
                    [
                        'INSERT INTO dumps (bot_id, name, content) VALUES (%(bot_id)s, %(name)s, %(content)s);',
                        {
                            'bot_id': bot_id,
                            'name': name,
                            'content': file.getvalue(),
                        },
                    ],
                ],
            )
