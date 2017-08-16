from app.factories.cosine_similarity_factory import CosineSimilarityFactory


class ReplyController:
    def __init__(self, factory=None):
        self._factory = factory if factory is not None else CosineSimilarityFactory()

    def perform(self, text):
        tokenized_sentences = self.factory.get_tokenizer().tokenize(text)
        self.factory.get_vectorizer().fit(tokenized_sentences)
        features = self.factory.get_vectorizer().transform(tokenized_sentences)
