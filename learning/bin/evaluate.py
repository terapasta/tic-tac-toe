import argparse

from app.controllers.evaluate_controller import EvaluateController
from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.context import Context


def evaluate():
    parser = argparse.ArgumentParser()
    parser.add_argument('--bot_id', default=1, type=int)
    parser.add_argument('--env', type=str, default='development')
    parser.add_argument('--algorithm', type=str, default=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)
    parser.add_argument('--feedback_algorithm', type=str, default=Constants.FEEDBACK_ALGORITHM_NONE)
    args = parser.parse_args()

    Config().init(args.env)

    # FIXME: fileを使うと以下のエラーが出る
    #        This solver needs samples of at least 2 classes in the data, but the data contains only one class: 0
    class LearningParameter:
        algorithm = args.algorithm
        feedback_algorithm = args.feedback_algorithm


    context = Context(args.bot_id, LearningParameter(), {})
    result = EvaluateController(context=context).perform()
    print(result)


if __name__ == "__main__":
    evaluate()
