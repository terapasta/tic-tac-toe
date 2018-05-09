# NOTE:
# グローバル変数としてラーニングフェーズか否かを記憶する
# グローバル変数はあまり使われるべきではないが、Keras の実装にも入っているのと、
# 用途も限定的なのでそれほど問題にはならないはず...
# https://github.com/tensorflow/tensorflow/blob/r1.8/tensorflow/python/keras/_impl/keras/backend.py#L362-L377
#
def set_learning_phase(is_learning_phase=True):
    global _LEARNING_PHASE
    _LEARNING_PHASE = is_learning_phase

def is_learning_phase():
    return _LEARNING_PHASE
