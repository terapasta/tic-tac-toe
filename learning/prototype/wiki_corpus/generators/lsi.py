import sys
import itertools
from gensim.corpora import Dictionary, MmCorpus
from gensim.models import LsiModel, TfidfModel

# Note: topics数などにもよりますが、12時間前後かかります

src, dst = sys.argv[1], sys.argv[2]

dictionary = Dictionary.load_from_text(src + '_wordids.txt.bz2')
wiki_mm = MmCorpus(src + '_bow.mm')
mm = MmCorpus(dst + '_myope.mm')
tfidf_corpus = TfidfModel(itertools.chain(wiki_mm, mm), id2word=dictionary, normalize=True)
lsi = LsiModel(corpus=tfidf_corpus, id2word=dictionary, num_topics=1000)
lsi.save(dst + '_myope_lsi_1000.model')
