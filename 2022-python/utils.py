"""
Shared functions for Advent of Code
"""
import time


def timer(func):
    """Print the runtime of the decorated function"""

    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__}: {round(end - start, 4)}s")
        return result

    return wrapper
