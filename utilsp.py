"""
Shared functions for Advent of Code
"""
import time
import logging
import dataclasses
import json


def test(func, input_: str, expected) -> None:
    assert (
        func(input_) == expected
    ), f"Test failed for {func.__name__}. Expected {expected}, got {func(input_)}"


@dataclasses.dataclass
class InputData:
    input: str = ""
    example_input: str = ""
    test_answer1 = None
    test_answer2 = None


def get_data(day: str) -> InputData:
    data = InputData()
    with open(f"../input/{day}.txt") as f:
        data.input = f.read()
    with open(f"../input/examples.json") as f:
        examples = json.load(f)
    data.example_input = examples[day].get("input", "")
    data.test_answer1 = examples[day]["answers"].get("part1", None)
    data.test_answer2 = examples[day]["answers"].get("part2", None)
    return data


def timer(func):
    """Print the runtime of the decorated function"""

    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__}: {round(end - start, 4)}s")
        return result

    return wrapper


class CustomFormatter(logging.Formatter):
    """Add custom colors to logging"""

    grey = "\x1b[38;20m"
    green = "\x1b[32;20m"
    yellow = "\x1b[33;20m"
    red = "\x1b[31;20m"
    bold_red = "\x1b[31;1m"
    reset = "\x1b[0m"
    format = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"

    FORMATS = {
        logging.DEBUG: grey + format + reset,
        logging.INFO: green + format + reset,
        logging.WARNING: yellow + format + reset,
        logging.ERROR: red + format + reset,
        logging.CRITICAL: bold_red + format + reset,
    }

    def format(self, record):
        log_fmt = self.FORMATS.get(record.levelno)
        formatter = logging.Formatter(log_fmt)
        formatter.datefmt = "%H:%M:%S"
        return formatter.format(record)


def get_logger(name: str, level: int = logging.INFO) -> logging.Logger:
    """Return a logger with the custom formatter"""
    logger = logging.getLogger(name)
    logger.setLevel(level)
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)
    ch.setFormatter(CustomFormatter())
    logger.addHandler(ch)
    return logger
