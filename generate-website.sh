#!/bin/bash

ROOT="$1"/
CUSTOM_URL="$2"

# echo "$ROOT"
# echo "$CUSTOM_URL"

echo "new website: '$ROOT'"
echo "hallo abc" > "$ROOT"/hallo.txt
mkdir "$ROOT"subdir
echo "bye abc" > "$ROOT"/subdir/bye.txt
mkdir "$ROOT"/subdir/subsubdir
echo "__ciao__" > "$ROOT"/subdir/subsubdir/ciao.md
mkdir "$ROOT"docs
echo "<h1>Hallo</h1><p>no content</p>" > "$ROOT"/docs/index.html

if [ -n "$CUSTOM_URL" ]
then
    echo "$CUSTOM_URL" > "$ROOT"/docs/CNAME
fi
