import sys
from gensim.corpora import Dictionary, MmCorpus
from gensim.models import LdaModel

# Note: topics数などにもよりますが、12時間前後かかります

src, dst = sys.argv[1], sys.argv[2]

dictionary = Dictionary.load_from_text(src + '_wordids.txt.bz2')
tfidf_corpus = MmCorpus(src + '_tfidf.mm')
lda = LdaModel(corpus=tfidf_corpus, id2word=dictionary, num_topics=1000)
lda.save(dst + '_lda_1000.model')
