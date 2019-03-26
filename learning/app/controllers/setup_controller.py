from app.shared.datasource.datasource import Datasource
from app.shared.logger import logger
from app.shared.base_cls import BaseCls


class SetupController(BaseCls):
    def __init__(self):
        self.datasource = Datasource.new()

    def perform(self):
        logger.info('no initialization processes found')
