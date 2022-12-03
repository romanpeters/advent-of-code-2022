#!/usr/bin/env python
import logging
import os
from pathlib import Path
import sys
import pytest


logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


items = []
for day in Path(".").glob("day*.py"):
    items.append((day.stem, "part1"))
    items.append((day.stem, "part2"))


@pytest.mark.parametrize("day, part", items)
def test_speed(day, part, benchmark):
    try:
        os.chdir("notebooks")
    except FileNotFoundError:
        pass
    assert os.getcwd().endswith("notebooks")
    sys.path.append(".")
    sys.path.append("..")

    logging.info(f"Checking {day} {part}")
    day_module = __import__(day)
    INPUT = getattr(day_module, "INPUT")
    benchmark(getattr(day_module, part), INPUT)
