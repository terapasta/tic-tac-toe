import inject
import io
from sklearn.externals import joblib
from app.shared.app_status import AppStatus
from app.shared.datasource.database.database import Database


class Persistence:
    @inject.params(database=Database)
    def __init__(self, database=None):
        self.database = database

    def load(self, name):
        bot = AppStatus().current_bot()
        records = self.database.select(
            'SELECT * FROM dumps WHERE bot_id = %(bot_id)s AND name = %(name)s;',
            {
                'bot_id': bot.id,
                'name': self.__generate_key(name),
            },
        )
        if len(records) > 0 and records['content'][0] is not None:
            file = io.BytesIO(records['content'][0])
            return joblib.load(file)

        return None

    def dump(self, obj, name):
        bot = AppStatus().current_bot()
        file = io.BytesIO()
        joblib.dump(obj, file)
        file.seek(0)
        self.database.execute_with_transaction(
                [
                    [
                        'DELETE FROM dumps WHERE bot_id = %(bot_id)s AND name = %(name)s;',
                        {
                            'bot_id': bot.id,
                            'name': self.__generate_key(name),
                        },
                    ],
                    [
                        'INSERT INTO dumps (bot_id, name, content) VALUES (%(bot_id)s, %(name)s, %(content)s);',
                        {
                            'bot_id': bot.id,
                            'name': self.__generate_key(name),
                            'content': file.getvalue(),
                        },
                    ],
                ],
            )

    def __generate_key(self, name):
        bot = AppStatus().current_bot()
        return 'alg{}_{}'.format(bot.algorithm, name)
