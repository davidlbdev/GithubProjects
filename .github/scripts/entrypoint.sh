#!/bin/bash

set -e

python3 /app/.github/scripts/todo.py | tee /app/task_output.txt
python3 /app/.github/scripts/todo-test.py | tee /app/test_output.txt

bash /app/.github/scripts/update_index.sh /app/task_output.txt /app/test_output.txt
