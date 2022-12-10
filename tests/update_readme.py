#!/usr/bin/env python
import os


def create_benchmark_file():
    with open("tests/pytest.log", "r") as f:
        lines = f.readlines()

    benchmark = []
    for line in lines:
        if (line.startswith("-" * 20) and "benchmark" in line) or benchmark:
            if line.startswith("=" * 20):
                break
            benchmark.append(line)

    with open("tests/benchmark.txt", "w") as f:
        f.write("".join(benchmark))
    print("Benchmark file created")


def update_readme():
    with open("README.md", "r") as f:
        lines = f.readlines()

    readme = []
    for line in lines:
        if line.startswith("## Benchmarks"):
            break
        readme.append(line)

    with open("tests/benchmark.txt", "r") as f:
        benchmark = f.read()

    with open("README.md", "w") as f:
        f.write("".join(readme))
        f.write("## Benchmarks\n```terminal\n")
        f.write(benchmark)

    print("README.md updated")


def main():
    assert os.path.exists("tests") and os.path.exists(
        "README.md"
    ), "Execute from project root"
    create_benchmark_file()
    update_readme()


if __name__ == "__main__":
    main()
