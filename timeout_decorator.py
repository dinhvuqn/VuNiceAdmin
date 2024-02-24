import threading
import time
import os
import signal
from functools import wraps

class TimeoutException(Exception):
    """Thrown when a timeout occurs in the `timeout` context manager."""
    pass

def _raise_exception(exception, exception_message):
    """ This function checks if a exception message is given.

    If there is no exception message, the default behaviour is maintained.
    If there is an exception message, the message is passed to the exception with the 'value' keyword.
    """
    if exception_message is None:
        raise exception()
    else:
        raise exception(exception_message)

def timeout(seconds=None, timeout_exception=TimeoutException, exception_message=None):
    """Add a timeout parameter to a function and return it.

    :param seconds: optional time limit in seconds or fractions of a second. If None is passed, no timeout is applied.
        This adds some flexibility to the usage: you can disable timing out depending on the settings.
    :type seconds: float

    :raises: TimeoutException if time limit is reached

    It is illegal to pass anything other than a function as the first
    parameter. The function is wrapped and returned to the caller.
    """
    def timeout_decorator(func):
        # Function to run the original function and handle timeout
        def target(func, args, kwargs):
            func(*args, **kwargs)
        
        @wraps(func)
        def wrapper(*args, **kwargs):
            new_kwargs = {
                'func': func,
                'args': args,
                'kwargs': kwargs
            }
            # Create and start the thread
            thd = threading.Thread(target=target, args=(), kwargs=new_kwargs)
            thd.start()
            thd.join(seconds)

            # Check the result and handle timeout
            if thd.is_alive():
                _raise_exception(timeout_exception, "tim out")

        return wrapper

    return timeout_decorator

# Use the decorator with a parameter to set a timeout of 5 seconds
@timeout(12)
def method_timeout(text):
    for sec in range(1, 10):
        try:
            if sec == 5:
                time.sleep(12)
            print('start', sec, text)
            print('finish', sec, text)
        except:
            continue
    return sec
if __name__ == '__main__':
    try:
        method_timeout('TIMEOUT!')
    except TimeoutException as e:
        print(e)
        current_process_id = os.getpid()
        os.kill(current_process_id, signal.SIGTERM)
        
