from app.core.preprocessor.base_preprocessor import BasePreprocessor


class PassPreprocessor(BasePreprocessor):
    def __init__(self):
        pass

    def perform(self, texts):
        return texts