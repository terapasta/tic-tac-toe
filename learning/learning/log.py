import logging
from logging.handlers import TimedRotatingFileHandler

format = '%(asctime)s %(message)s'
logging.basicConfig(format=format, datefmt='%Y/%m/%d %p %I:%M:%S',)
formatter = logging.Formatter(format)
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

# file handler
fhandler = TimedRotatingFileHandler("./logs/application.log", when='D', backupCount=30)
fhandler.setLevel(logging.DEBUG)
fhandler.setFormatter(formatter)
logger.addHandler(fhandler)
