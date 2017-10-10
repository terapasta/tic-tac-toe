import inject
import numpy as np
from app.shared.constants import Constants
from app.shared.current_bot import CurrentBot


class QuestionAnswerDataBuiler:
    @inject.params(bot=CurrentBot)
    def __init__(self, tokenizer, datasource, bot=None):
        self.bot = bot if bot is not None else CurrentBot()
        self.tokenizer = tokenizer
        self.datasource = datasource

    def build_tokenized_vocabularies(self, datasource, tokenizer):
        all_question_answers_data = self.datasource.question_answers.all()
        return tokenizer.tokenize(all_question_answers_data['question'])

    def build_learning_data(self, bot_id):
        raw_data = self.datasource.question_answers.by_bot(bot_id)
        bot_tokenized_sentences = self.tokenizer.tokenize(raw_data['question'])

        # Note: 空のテキストにラベル0を対応付けるために強制的にトレーニングセットを追加
        bot_tokenized_sentences = np.array(bot_tokenized_sentences)
        bot_tokenized_sentences = np.append(bot_tokenized_sentences, [''] * Constants.COUNT_OF_APPEND_BLANK)
        question_answer_ids = np.array(raw_data['question_answer_id'], dtype=np.int)
        question_answer_ids = np.append(question_answer_ids, [Constants.CLASSIFY_FAILED_ANSWER_ID] * Constants.COUNT_OF_APPEND_BLANK)

        return bot_tokenized_sentences, question_answer_ids
