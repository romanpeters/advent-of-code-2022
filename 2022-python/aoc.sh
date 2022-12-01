#! /bin/bash

# commandline utility
# usage: ./aoc.sh <command>
# commands:
#   - init - setup dev environment
#   - build - compile utils_.c to utils_.so
#   - run - start jupyter notebook server
#   - new - create new notebook
#   - check - run pre-commit hook and check for errors

function init() {
    python -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    pre-commit install
    cc -shared -fPIC -o utils_.so utils_.c
    echo "environment setup complete"
}

function build() {
    cc -shared -fPIC -o utils_.so utils_.c
    echo "utils_.so built"
}

function run() {
    source venv/bin/activate
    jupyter notebook
}

function new() {
    # check for existing notebooks
    if [ -z "$(ls -A | grep day01.ipynb)" ]; then
        # no notebooks exist, create first notebook
        echo "no notebooks exist, creating first notebook"
        mkdir -p input notebooks
        touch input/day01.txt
        jinja -D day day01 template.ipynb.j2 > notebooks/day01.ipynb
        echo "day01.ipynb created"
    else
        # notebooks exist, create new notebook
        last_notebook=$(ls -1 | grep day | tail -n 1)
        last_day=$(echo $last_notebook | cut -d'.' -f1 | cut -d'y' -f2)
        new_day=$((last_day + 1))
        touch input/day$(printf "%02d" $new_day).txt
        jinja -D day day$(printf "%02d" $new_day) template.ipynb.j2 > notebooks/day$(printf "%02d" $new_day).ipynb
        echo "day$(printf "%02d" $new_day).ipynb created"
    fi

    }

function check() {
    pre-commit run --all-files
    jupyter execute notebooks/*
}

case $1 in
    init)
        init
        ;;
    build)
        build
        ;;
    run)
        run
        ;;
    new)
        new
        ;;
    check)
        check
        ;;
    *)
        echo "usage: aoc <command>"
        echo "commands:"
        echo "  - init - setup dev environment"
        echo "  - build - compile utils_.c to utils_.so"
        echo "  - run - start jupyter notebook server"
        echo "  - new - create new notebook"
        echo "  - check - run pre-commit hook and check for errors"
        ;;
esac
