from learning.core.datasource import Datasource


class Synonym:
    def __init__(self, bot_id, datasource=None):
        self.bot_id = bot_id
        self.datasource = Datasource() if datasource is None else datasource
        self.learning_training_messages = self.datasource.learning_training_messages(self.bot_id)
        self.word_mappings = self.datasource.word_mappings_for_bot(self.bot_id)

    def unify(self, text):
        self.datasource.update_learning_training_messages(self.learning_training_messages)

        print('hogehoge')
