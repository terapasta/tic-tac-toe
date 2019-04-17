import logging
from logging.handlers import TimedRotatingFileHandler
from app.shared.config import Config

log_level = logging.DEBUG
if Config.env != 'development':
    log_level = logging.INFO

format = '[%(levelname)5s %(thread)d %(asctime)s %(module)27s:%(lineno)3s - %(funcName)22s] %(message)s'
logging.basicConfig(format=format, datefmt='%Y/%m/%d %p %I:%M:%S',)
formatter = logging.Formatter(format)
logger = logging.getLogger(__name__)
logger.setLevel(log_level)

# file handler
fhandler = TimedRotatingFileHandler("./logs/application.log", when='D', backupCount=30, encoding='utf-8')
fhandler.setLevel(log_level)
fhandler.setFormatter(formatter)
logger.addHandler(fhandler)


def disable_logging():
    logger.disabled = True

def enable_logging():
    logger.disabled = False
