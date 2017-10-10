import argparse

import inject

from app.controllers.learn_controller import LearnController
from app.factories.factory_selector import FactorySelector
from app.shared.config import Config
from app.shared.constants import Constants
from app.shared.current_bot import CurrentBot
from app.shared.datasource.datasource import Datasource

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)
parser.add_argument('--env', type=str, default='development')
parser.add_argument('--use_similarity_classification', type=str, default='true')
parser.add_argument('--algorithm', type=str, default=Constants.ALGORITHM_TWO_STEP_SIMILARITY_CLASSIFICATION)
parser.add_argument('--datasource', type=str, default=Constants.DATASOURCE_TYPE_DATABASE)
args = parser.parse_args()
Config().init(args.env)
inject.configure_once()


# FIXME: fileを使うと以下のエラーが出る
#        This solver needs samples of at least 2 classes in the data, but the data contains only one class: 0
class LearningParameter:
    datasource_type = args.datasource
    use_similarity_classification = args.use_similarity_classification
    algorithm = args.algorithm


bot = CurrentBot().init(args.bot_id, LearningParameter())
Datasource().init(bot)
result = LearnController(factory=FactorySelector().get_factory()).perform()
print(result)
