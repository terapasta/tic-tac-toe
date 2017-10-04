from app.shared.logger import logger
import numpy as np


class QuestionAnswerDataBuiler:
    raw_data = None

    def build(self, datasource, tokenizer):
        all_question_answers_data = datasource.question_answers.all()
        return tokenizer.tokenize(all_question_answers_data['question'])


    def build_by_bot(self, datasource, tokenizer, bot_id):
        self.raw_data = datasource.question_answers.by_bot(bot_id)
        return tokenizer.tokenize(self.raw_data['question'])
