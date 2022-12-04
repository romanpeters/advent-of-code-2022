import os
import sys


def set_cwd_notebooks():
    try:
        os.chdir("notebooks")
    except FileNotFoundError:
        pass
    assert os.getcwd().endswith("notebooks")
    sys.path.append(".")
    sys.path.append("..")
