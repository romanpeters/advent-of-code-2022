#!/usr/bin/env python
import logging
import os
from pathlib import Path
import sys


logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

answers = {
    "day01": {"part1": 71300, "part2": 209691},
    "day02": {"part1": 14827, "part2": 13889},
    "day03": {"part1": 7817, "part2": 2444},
}


def test_check_answers():
    """Imports the notebooks/dayXX.py files and checks the answers"""
    os.chdir("notebooks")
    sys.path.append(os.getcwd())
    print("let's check the answers")
    for day in Path(".").glob("day*.py"):
        logging.info(f"Checking {day}")
        day_module = __import__(day.stem)
        assert answers[day.stem]["part1"] == getattr(day_module, "part1")(
            getattr(day_module, "INPUT")
        )
        assert answers[day.stem]["part2"] == getattr(day_module, "part2")(
            getattr(day_module, "INPUT")
        )
    logging.info("All answers correct")


if __name__ == "__main__":
    test_check_answers()
