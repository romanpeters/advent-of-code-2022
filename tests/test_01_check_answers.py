#!/usr/bin/env python
import logging
from pathlib import Path
from . import set_cwd_notebooks

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

answers = {
    "day01": {"part1": 71300, "part2": 209691},
    "day02": {"part1": 14827, "part2": 13889},
    "day03": {"part1": 7817, "part2": 2444},
    "day04": {"part1": 464, "part2": 770},
}


def test_check_answers():
    set_cwd_notebooks()

    """Imports the notebooks/dayXX.py files and checks the answers"""
    py_files = Path(".").glob("day*.py")
    assert len([p for p in py_files]) == len(
        answers.keys()
    ), f"Found {len([p for p in py_files])} notebooks, expected {len(answers.keys())}"
    for day in py_files:
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
