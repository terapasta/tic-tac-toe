from app.core.tokenizer.mecab_tokenizer_with_split import MecabTokenizerWithSplit


class MecabTokenizer(MecabTokenizerWithSplit):
    def tokenize_single_text(self, text):
        word_list = super().tokenize_single_text(text)
        return " ".join(word_list)
