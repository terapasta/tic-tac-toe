from enum import Enum


class PartOfSpeech(Enum):
    NOUN = 1
    VERB = 2
    ADJECTIVE = 3
    INTERJECTION = 4
    AUXILIARY_VERB = 5
    ADVERB = 6

    @classmethod
    def from_word(self, pos):
        if pos == '名詞':
            return PartOfSpeech.NOUN
        elif pos == '動詞':
            return PartOfSpeech.VERB
        elif pos == '形容詞':
            return PartOfSpeech.ADJECTIVE
        elif pos == '感嘆詞':
            return PartOfSpeech.INTERJECTION
        elif pos == '助動詞':
            return PartOfSpeech.AUXILIARY_VERB
        elif pos == '副詞':
            return PartOfSpeech.ADVERB
        else:
            return None