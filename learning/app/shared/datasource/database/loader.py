import inject
import io
import re
from sklearn.externals import joblib
from app.shared.current_bot import CurrentBot
from app.shared.datasource.database.database import Database


class Loader:
    @inject.params(database=Database, bot=CurrentBot)
    def __init__(self, database=None, bot=None):
        self.database = database
        self.bot = bot

    def load(self, key):
        records = self.database.select(
            'SELECT * FROM bots WHERE id = %(bot_id)s',
            {
                'key': key,
                'bot_id': self.bot.id,
            },
        )
        if len(records) > 0 and records[key][0] is not None:
            file = io.BytesIO(records[key][0])
            return joblib.load(file)

        return None

    def dump(self, obj, key):
        file = io.BytesIO()
        joblib.dump(obj, file)
        file.seek(0)
        # Note: SQLインジェクションを回避するためkeyのチェックを行う
        if re.match(r'^[a-zA-Z_]+$', key):
            sql = 'UPDATE bots SET ' + key + '=%(value)s WHERE id = %(bot_id)s'
            self.database.execute(sql, {
                    'key': key,
                    'value': file.getvalue(),
                    'bot_id': self.bot.id,
                },)
        else:
            raise ValueError('dump column is invalid')
