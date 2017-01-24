import pandas as pd

from learning.core.training_set.text_array import TextArray
from sklearn.metrics.pairwise import cosine_similarity

# 質問文間でコサイン類似度を算出して、近い質問文の候補を取得する実装

data = pd.read_csv('cosine_similarity.csv')
text_array = TextArray(data['question'])
x = text_array.to_vec()
question_array = TextArray(['OutlookでBCC'], vectorizer=text_array.vectorizer)
# print(text_array.to_vec(type='array'))
y = question_array.to_vec()


similarities = cosine_similarity(x,y)
similarities = similarities.flatten()
print(similarities)

ordered_result = list(map(lambda x: {
    'question': x[0], 'similarity': x[1]
}, sorted(zip(data['question'], similarities), key=lambda x: x[1], reverse=True)))


for row in ordered_result:
    print(row)
