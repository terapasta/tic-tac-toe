from functools import wraps
import time

from learning.log import logger


def stop_watch(func) :
    @wraps(func)
    def wrapper(*args, **kargs) :
        start = time.time()
        result = func(*args,**kargs)
        elapsed_time =  time.time() - start
        class_name= args[0].__class__.__name__
        func_name = func.__name__
        logger.debug("%s processing time: %s [sec]" % ((class_name + '.' + func_name), elapsed_time))
        return result
    return wrapper