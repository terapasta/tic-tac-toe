import os
from sklearn.externals import joblib
from gensim import corpora, models

MAX_COUNT = 6796444
IS_SAVE = True
STEP = 1000
TOPICS = 1000

ENABLE_ID_CORPUS = False
ENABLE_TFIDF = False

gensim_dictionary = joblib.load('../working/gensim_dict_by_joblib.pkl')
if ENABLE_ID_CORPUS:
    i = 0
    j = STEP
    id_corpus_list = []
    tokenized_sentences = []

    while i < MAX_COUNT:
        filepath = '../working/tokenized_sentences_list_{start}-{end}'.format(start=i, end=j)
        print(filepath)
        if not os.path.exists(filepath):
            i = i + STEP
            j = j + STEP
            continue
        tokenized_sentences = joblib.load(filepath)
        id_corpus = [gensim_dictionary.doc2bow(sentence, allow_update=True) for sentence in tokenized_sentences]
        id_corpus_list = id_corpus_list + id_corpus
        i = i + STEP
        j = j + STEP

    if IS_SAVE:
        print('serialize')
        corpora.MmCorpus.serialize('../working/gensim.mm', id_corpus_list)
        print('update dictionary')
        joblib.dump(gensim_dictionary, '../working/gensim_dict_by_joblib_update.pkl')

if ENABLE_TFIDF:
    print('tfidf')
    tfidf = models.TfidfModel(id_corpus_list)

    if IS_SAVE:
        print('tfidf save')
        tfidf.save('../working/gensim.tfidf')
        print('tfidf dump')
        joblib.dump(tfidf, '../working/gensim_tfidf_by_joblib.pkl')

print('lsi')
i = 0
j = STEP
lsi = models.LsiModel(num_topics=TOPICS, id2word=gensim_dictionary)
while i < MAX_COUNT:
    filepath = '../working/tokenized_sentences_list_{start}-{end}'.format(start=i, end=j)
    print(filepath)
    if not os.path.exists(filepath):
        i = i + STEP
        j = j + STEP
        continue
    tokenized_sentences = joblib.load(filepath)
    id_corpus = [gensim_dictionary.doc2bow(sentence, allow_update=True) for sentence in tokenized_sentences]
    tfidf_corpus = tfidf[id_corpus]
    # TODO: ここで落ちる
    #       [1]    6298 segmentation fault  python make.py
    lsi.add_documents(tfidf_corpus)
    i = i + STEP
    j = j + STEP

print(lsi)

if IS_SAVE:
    print('lsi save')
    lsi.save('../working/gensim_lsi')
    print('lsi dump')
    joblib.dump(lsi, '../working/gensim_lsi_by_joblib.pkl')
    print('id_corpus dump')
    joblib.dump(id_corpus_list, '../working/id_corpus')

queries = ['アルファベット', '時期']
query_vector = gensim_dictionary.doc2bow(queries)
print(query_vector)

vec_lsi = lsi[query_vector]
print(vec_lsi)
