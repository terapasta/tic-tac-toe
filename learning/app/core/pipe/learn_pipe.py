from app.shared.base_cls import BaseCls
from app.shared.logger import logger


class LearnPipe(BaseCls):
    def __init__(self, factory):
        self._factory = factory

    def perform(self, texts):
        # ベクトル化前の自然言語処理
        tokenized = self.before_vectorize(texts)

        # ベクトル化
        vectors = self._vectorize(tokenized)

        # ベクトル化後の正規化処理
        results = self.after_vectorize(vectors)

        return results

    def before_vectorize(self, texts):
        pipes = [self._preprocess, self._tokenize]
        return self._apply_pipes(texts, pipes)

    def vectorize(self, texts):
        pipes = [self._vectorize]
        return self._apply_pipes(texts, pipes)

    def after_vectorize(self, vectors):
        pipes = [self._reduce, self._normalize]
        return self._apply_pipes(vectors, pipes)

    def _apply_pipes(self, data, pipes):
        results = data
        for pipe in pipes:
            results = pipe(results)
        return results

    def _preprocess(self, texts):
        logger.info('preprocess')
        return self._factory.get_preprocessor().perform(texts)

    def _tokenize(self, texts):
        logger.info('tokenize')
        return self._factory.get_tokenizer().tokenize(texts)

    def _vectorize(self, texts):
        logger.info('fit vectorizer')
        return self._factory.get_vectorizer().fit_transform(texts)

    def _reduce(self, vectors):
        logger.info('fit reducer')
        return self._factory.get_reducer().fit_transform(vectors)

    def _normalize(self, vectors):
        logger.info('fit normalizer')
        return self._factory.get_normalizer().fit(vectors)
