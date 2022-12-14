#!/usr/bin/env python
import logging
from pathlib import Path
import json
import aoc

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


def test_check_answers():
    """Imports the notebooks/dayXX.py files and checks the answers"""
    with open(Path("../tests/answers.json")) as f:
        answers = json.load(f)

    assert Path("day01.py").exists(), "day01.py not found"

    # if the for-loop doesn't loop, throw an error
    for day in Path(".").glob("*.py"):
        logging.info(f"Checking {day}")
        day_module = __import__(day.stem)
        data = aoc.get_data(day.stem)
        assert answers[day.stem]["answers"]["part1"] == getattr(day_module, "part1")(data.input)
        assert answers[day.stem]["answers"]["part2"] == getattr(day_module, "part2")(data.input)
    logging.info("All answers correct")
