import pandas as pd


class WikiCorpus:
    def __init__(self):
        self._data = pd.read_table('/Users/shwld/Downloads/wiki-corpus/jawiki.txt')

    def all(self):
        return self._data
