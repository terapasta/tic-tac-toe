from app.shared.base_cls import BaseCls
from app.shared.logger import logger


class ReplyPipe(BaseCls):
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
        pipes = [self._preprocess, self._tokenize, self._merge]
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
        logger.info('tokenize question')
        tokenized = self._factory.get_tokenizer().tokenize(texts)
        logger.debug(tokenized)
        return tokenized

    def _merge(self, texts, separator=' '):
        # スペース区切りの複数の文章をまとめる
        #
        # e.g.,
        # ['ぷりんたー いれる 電源 が わかる 方 わかり いれ の', 'いれる 電源 が わかる 方 わかり いれ の ぷりんた']
        # => ['ぷりんた わかる 電源 いれる が いれ わかり ぷりんたー の 方']
        #
        dic = {}
        for text in texts:
            for word in text.split(separator):
                dic[word] = True
        return [separator.join(dic.keys())]

    def _vectorize(self, texts):
        logger.info('vectorize question')
        return self._factory.get_vectorizer().transform(texts)

    def _reduce(self, vectors):
        logger.info('reduce question')
        return self._factory.get_reducer().transform(vectors)

    def _normalize(self, vectors):
        logger.info('normalize question')
        return self._factory.get_normalizer().transform(vectors)
