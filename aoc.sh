#!/usr/bin/env bash

# commandline utility
# usage: ./aoc.sh <command>
# commands:
#   - init - setup dev environment
#   - build - compile utilsc.c to utilsc.so
#   - run - start jupyter notebook server
#   - new - create new notebook
#   - test - run pre-commit hook and tests

function init() {
    # check if the script is run with 'source' command
    if [[ $0 != $BASH_SOURCE ]]; then
        # if yes, activate venv
        python3 -m venv venv
        source venv/bin/activate
    else
        # if no, print message
        echo "Please run this command with 'source'"
        echo "Example: source ./aoc.sh init"
        exit 1
    fi
    pip install -r requirements.txt
    pre-commit install
    cc -shared -fPIC -o utilsc.so utilsc.c
    echo "environment setup complete"
}

function build() {
    cc -shared -fPIC -o utilsc.so utilsc.c
    echo "utilsc built"
}

function run() {
    source venv/bin/activate
    jupyter notebook
}

function new() {
    # check for existing notebooks
    if [ -z "$(ls -A notebooks)" ]; then
        # no notebooks exist, create first notebook
        echo "no notebooks exist, creating first notebook"
        mkdir -p input notebooks
        touch input/day01.txt
        jinja -D day day01 template.ipynb.j2 > notebooks/day01.ipynb
        echo "day01.ipynb created"
    else
        # notebooks exist, create new notebook
        last_notebook=$(ls -1 notebooks | tail -n 1)
        last_day=$(echo $last_notebook | cut -d'.' -f1 | cut -d'y' -f2)
        new_day=$((last_day + 1))
        touch input/day$(printf "%02d" $new_day).txt
        jinja -D day day$(printf "%02d" $new_day) template.ipynb.j2 > notebooks/day$(printf "%02d" $new_day).ipynb
        echo "day$(printf "%02d" $new_day).ipynb created"
    fi

    }

function test() {
    pre-commit run --all-files
    pytest
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
    test)
        test
        ;;
    *)
        echo "usage: source|sh ./aoc.sh <command>"
        echo "commands:"
        echo "  - init - setup dev environment"
        echo "  - build - compile utilsc.c to utilsc.so"
        echo "  - run - start jupyter notebook server"
        echo "  - new - create new notebook"
        echo "  - test - run pre-commit hook and tests"
        ;;
esac