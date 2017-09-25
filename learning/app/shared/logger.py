import logging
from logging.handlers import TimedRotatingFileHandler

format = '[%(levelname)5s %(asctime)s %(module)25s:%(lineno)3s - %(funcName)20s] %(message)s'
logging.basicConfig(format=format, datefmt='%Y/%m/%d %p %I:%M:%S',)
formatter = logging.Formatter(format)
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

# file handler
fhandler = TimedRotatingFileHandler("./logs/application.log", when='D', backupCount=30, encoding='utf-8')
fhandler.setLevel(logging.DEBUG)
fhandler.setFormatter(formatter)
logger.addHandler(fhandler)
