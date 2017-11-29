from app.shared.base_cls import BaseCls


class BaseFactory(BaseCls):
    def get_tokenizer(self):
        raise NotImplementedError()

    def get_vectorizer(self):
        raise NotImplementedError()

    def get_reducer(self):
        raise NotImplementedError()

    def get_normalizer(self):
        raise NotImplementedError()

    def get_estimator(self):
        raise NotImplementedError()

    def get_datasource(self):
        raise NotImplementedError()

    @property
    def core(self):
        raise NotImplementedError()

    @property
    def feedback(self):
        raise NotImplementedError()
