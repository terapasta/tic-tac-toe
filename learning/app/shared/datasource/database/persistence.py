import io
from sklearn.externals import joblib
from app.shared.datasource.database.database import Database
from app.shared.base_cls import BaseCls


class Persistence(BaseCls):
    def __init__(self):
        self.database = Database()
        self.id = 0
        self.algorithm = 'none'

    def init_by_bot(self, bot):
        self.id = bot.id
        self.algorithm = bot.algorithm
        return self

    def load(self, key):
        records = self.database.select(
            'SELECT * FROM dumps WHERE bot_id = %(bot_id)s AND name = %(name)s;',
            {
                'bot_id': self.id,
                'name': self._generate_name(key),
            },
        )
        if len(records) > 0 and records['content'][0] is not None:
            file = io.BytesIO(records['content'][0])
            return joblib.load(file)

        return None

    def dump(self, obj, key):
        file = io.BytesIO()
        joblib.dump(obj, file)
        file.seek(0)
        self.database.execute_with_transaction(
                [
                    [
                        'DELETE FROM dumps WHERE bot_id = %(bot_id)s AND name = %(name)s;',
                        {
                            'bot_id': self.id,
                            'name': self._generate_name(key),
                        },
                    ],
                    [
                        'INSERT INTO dumps (bot_id, name, content) VALUES (%(bot_id)s, %(name)s, %(content)s);',
                        {
                            'bot_id': self.id,
                            'name': self._generate_name(key),
                            'content': file.getvalue(),
                        },
                    ],
                ],
            )

    def _generate_name(self, key):
        return 'alg{}_{}'.format(self.algorithm, key)
