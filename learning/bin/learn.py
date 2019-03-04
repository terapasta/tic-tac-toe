import argparse

from app.controllers.learn_controller import LearnController
from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.context import Context

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)
parser.add_argument('--env', type=str, default='development')
parser.add_argument('--algorithm', type=str, default=Constants.ALGORITHM_STRICT_FUZZY_COSINE_SIMILARITY_CLASSIFICATION)
parser.add_argument('--feedback_algorithm', type=str, default=Constants.FEEDBACK_ALGORITHM_ROCCHIO)
args = parser.parse_args()

Config().init(args.env)


# FIXME: fileを使うと以下のエラーが出る
#        This solver needs samples of at least 2 classes in the data, but the data contains only one class: 0
class LearningParameter:
    algorithm = args.algorithm
    feedback_algorithm = args.feedback_algorithm


context = Context(args.bot_id, LearningParameter(), {}, phase=Constants.PHASE_LEARNING)
result = LearnController(context=context).perform()
print(result)
