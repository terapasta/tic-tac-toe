import json
import traceback
from app.shared.logger import logger
from app.shared.datasource.database.database import Database
from app.shared.base_cls import BaseCls


class LearningParameters(BaseCls):
    def __init__(self):
        self.database = Database()

    def feedback_parameters(self, bot_id, algorithm):
        parameters = self.database.select(
                "select * from learning_parameters where bot_id = %(bot_id)s;",
                params={'bot_id': bot_id}
            )

        try:
            data = json.loads(parameters['parameters_for_feedback'][0])
            return data[str(algorithm)]
        except:
            logger.debug(traceback.format_exc())
            return {}
