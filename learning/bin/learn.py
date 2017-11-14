import argparse

import inject

from app.controllers.learn_controller import LearnController
from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.context import Context

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)
parser.add_argument('--env', type=str, default='development')
parser.add_argument('--algorithm', type=str, default=Constants.ALGORITHM_SIMILARITY_CLASSIFICATION)
args = parser.parse_args()

inject.configure_once()
Config().init(args.env)


# FIXME: fileを使うと以下のエラーが出る
#        This solver needs samples of at least 2 classes in the data, but the data contains only one class: 0
class LearningParameter:
    algorithm = args.algorithm


context = Context(args.bot_id, LearningParameter(), {})
result = LearnController(context=context).perform()
print(result)
