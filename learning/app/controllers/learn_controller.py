from app.factories.cosine_similarity_factory import CosineSimilarityFactory
from app.shared.current_bot import CurrentBot


class LearnController:
    def __init__(self, bot=None, factory=None):
        self.bot = bot if bot is not None else CurrentBot()
        self._factory = factory if factory is not None else CosineSimilarityFactory()

    def perform(self):
        all_learning_training_messages_data = self._factory.get_learning_training_messages().all()
        tokenized_sentences = self._factory.get_tokenizer().tokenize(all_learning_training_messages_data['question'])
        self._factory.get_vectorizer().fit(tokenized_sentences)

        return {
            'accuracy': 0,
            'precision': 0,
            'recall': 0,
            'f1': 0,
        }
