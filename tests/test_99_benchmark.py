import logging
import pytest
import utilsp


logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


def generate_input():
    items = [(f"day{i:02d}", "part1") for i in range(1, 26)]
    items += [(f"day{i:02d}", "part2") for i in range(1, 26)]
    return items


@pytest.mark.parametrize("input", generate_input())
def test_speed(benchmark, input):
    day, part = input
    logging.info(f"Checking {day} {part}")
    try:
        day_module = __import__(day)
    except ModuleNotFoundError:
        logging.info(f"Skipping {day} {part}")
        return
    data = utilsp.get_data(day)
    benchmark.name = f"{day} {part}"
    cap = benchmark(getattr(day_module, part), data.input)
