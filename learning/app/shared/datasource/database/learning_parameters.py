import json
from app.shared.logger import logger
from app.shared.datasource.database.database import Database
from app.shared.base_cls import BaseCls


class LearningParameters(BaseCls):
    def __init__(self):
        self.database = Database()

    def feedback_parameters(self, bot_id, algorithm):
        parameters = self._feedback_parameters(bot_id)

        try:
            data = json.loads(parameters['parameters_for_feedback'][0])
            return data[str(algorithm)]
        except:
            logger.debug('no learning parameter for feedback')
            return {}

    def feedback_threshold(self, bot_id):
        parameters = self._feedback_parameters(bot_id)

        try:
            data = json.loads(parameters['parameters_for_feedback'][0])
            return data['threshold']
        except:
            logger.debug('no learning parameter for feedback threshold')
            return 0.1

    def _feedback_parameters(self, bot_id):
        return self.database.select(
                "select * from learning_parameters where bot_id = %(bot_id)s;",
                params={'bot_id': bot_id}
            )
