#!/bin/bash

TASK_OUTPUT_FILE=$1
TEST_OUTPUT_FILE=$2
HTML_FILE="index.html"

TODO_TASKS=$(awk '/ToDo Tasks:/{flag=1; next} /Done Tasks:/{flag=0} flag' "$TASK_OUTPUT_FILE")
DONE_TASKS=$(awk '/Done Tasks:/{flag=1; next} flag' "$TASK_OUTPUT_FILE")
TEST_RESULTS=$(cat "$TEST_OUTPUT_FILE")

update_pre() {
    local id=$1
    local content=$2
    local file=$3

    perl -0777 -i -pe "s|<pre id=\"$id\">.*?</pre>|<pre id=\"$id\">$content</pre>|gs" "$file"
}

update_pre "todo-tasks" "$TODO_TASKS" "$HTML_FILE"
update_pre "done-tasks" "$DONE_TASKS" "$HTML_FILE"
update_pre "test-results" "$TEST_RESULTS" "$HTML_FILE"

git config --global user.email "github-actions@github.com"
git config --global user.name "GitHub Actions"

git add index.html
git commit -m "Update index.html with task and test results" || echo "No changes to commit"
git push || echo "Push skipped or failed"
