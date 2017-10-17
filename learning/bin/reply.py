import argparse

import inject

from app.controllers.reply_controller import ReplyController
from app.factories.factory_selector import FactorySelector
from app.shared.current_bot import CurrentBot
from app.shared.datasource.datasource import Datasource
from app.shared.config import Config
from app.shared.constants import Constants

parser = argparse.ArgumentParser()
parser.add_argument('--bot_id', default=1, type=int)  # Rails側と重複しないIDを指定
parser.add_argument('--env', type=str, default='development')
parser.add_argument('--question', type=str, default='プリン食べたい')
parser.add_argument('--algorithm', type=str, default=Constants.ALGORITHM_TWO_STEP_SIMILARITY_CLASSIFICATION)
parser.add_argument('--datasource', type=str, default=Constants.DATASOURCE_TYPE_DATABASE)
args = parser.parse_args()
Config().init(args.env)
inject.configure_once()


class LearningParameter:
    datasource_type = args.datasource
    algorithm = args.algorithm


bot = CurrentBot().init(args.bot_id, LearningParameter())
Datasource().init(bot)
result = ReplyController(factory=FactorySelector().get_factory()).perform(args.question)
print(result)
