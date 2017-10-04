from app.shared.logger import logger
import numpy as np


class QuestionAnswerAppendedIdDataBuiler:
    raw_data = None

    def build(self, datasource, tokenizer):
        all_question_answers_data = datasource.question_answers.all()
        return self.__tokenize(all_question_answers_data, tokenizer)


    def build_by_bot(self, datasource, tokenizer, bot_id):
        self.raw_data = datasource.question_answers.by_bot(bot_id)
        return self.__tokenize(self.raw_data, tokenizer)


    def __tokenize(self, df, tokenizer):
        logger.info('tokenize all question_answers')
        tokenized_sentences = tokenizer.tokenize(df['question'])
        tokenized_sentences = np.array(tokenized_sentences, dtype=object)
        tokenized_sentences = tokenized_sentences + ' MYOPE_QA_ID:' + df['question_answer_id'].astype(str)
        return tokenized_sentences

