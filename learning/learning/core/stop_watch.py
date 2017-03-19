from functools import wraps
import time

from learning.log import logger


def stop_watch(func) :
    @wraps(func)
    def wrapper(*args, **kargs) :
        start = time.time()
        result = func(*args,**kargs)
        elapsed_time =  time.time() - start
        # HACK 関数のファクション名も含めたい(__module__使える？)
        logger.debug("%s processing time: %s [sec]" % (func.__name__, elapsed_time))
        return result
    return wrapper