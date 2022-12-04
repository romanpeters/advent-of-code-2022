#!/usr/bin/env python
import logging
from pathlib import Path
import pytest
from . import set_cwd_notebooks


logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


def generate_input():
    set_cwd_notebooks()
    items = []

    for day in Path(".").glob("day*.py"):
        items.append((day.stem, "part1"))
        items.append((day.stem, "part2"))
    return items


@pytest.mark.benchmark(group="benchmark")
@pytest.mark.parametrize("input", generate_input())
def test_speed(benchmark, input):
    set_cwd_notebooks()
    day, part = input
    logging.info(f"Checking {day} {part}")
    day_module = __import__(day)
    INPUT = getattr(day_module, "INPUT")
    benchmark.name = f"{day} {part}"
    benchmark(getattr(day_module, part), INPUT)
