import argparse

from app.controllers.reply_controller import ReplyController
from app.shared.context import Context
from app.shared.config import Config
from app.shared.constants import Constants

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)  # Rails側と重複しないIDを指定
parser.add_argument('--env', type=str, default='development')
parser.add_argument('--question', type=str, default='プリン食べたい')
parser.add_argument('--algorithm', type=str, default=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)
parser.add_argument('--feedback_algorithm', type=str, default=Constants.FEEDBACK_ALGORITHM_NONE)
args = parser.parse_args()

Config().init(args.env)


class LearningParameter:
    algorithm = args.algorithm
    feedback_algorithm = args.feedback_algorithm


context = Context(args.bot_id, LearningParameter(), {})
result = ReplyController(context=context).perform(args.question)
print(result)
