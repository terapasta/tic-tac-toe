import logging
from logging.handlers import TimedRotatingFileHandler

format = '[%(levelname)5s %(thread)d %(asctime)s %(module)27s:%(lineno)3s - %(funcName)22s] %(message)s'
logging.basicConfig(format=format, datefmt='%Y/%m/%d %p %I:%M:%S',)
formatter = logging.Formatter(format)
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

# file handler
fhandler = TimedRotatingFileHandler("./logs/application.log", when='D', backupCount=30, encoding='utf-8')
fhandler.setLevel(logging.DEBUG)
fhandler.setFormatter(formatter)
logger.addHandler(fhandler)
