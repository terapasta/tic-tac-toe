from app.shared.base_cls import BaseCls


class LearningParameters(BaseCls):
    def __init__(self):
        pass

    def feedback_parameters(self, bot_id, algorithm):
        # TODO: fileをでパラメータを設定できるようにする
        return {}

    def feedback_threshold(self, bot_id):
        # https://www.pivotaltracker.com/story/show/157344812
        return 0.7
