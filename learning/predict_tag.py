from learning.core.predict.tag import Tag
X = [
    'こんにちは',
    'パソコンが壊れました。どうすればいいですか？',
    'パソコンが壊れちゃった。',
]
Tag().predict(X)
