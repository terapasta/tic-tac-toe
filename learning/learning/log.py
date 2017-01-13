import logging
from logging import getLogger,StreamHandler,FileHandler,DEBUG
from logging.handlers import TimedRotatingFileHandler

logging.basicConfig(format='%(asctime)s %(message)s',
datefmt='%Y/%m/%d %p %I:%M:%S',)

logger = getLogger(__name__)
logger.setLevel(DEBUG)

# stream handler
handler = StreamHandler()
handler.setLevel(DEBUG)
logger.addHandler(handler)

# file handler
fhandler = TimedRotatingFileHandler("./logs/application.log", when='D', backupCount=30)
fhandler.setLevel(DEBUG)
logger.addHandler(fhandler)
