#!/bin/bash

ROOT="$1"/
echo "new website: '$ROOT'"
echo "hallo abc" > "$ROOT"/hallo.txt
mkdir "$ROOT"subdir
echo "bye abc" > "$ROOT"/subdir/bye.txt
mkdir "$ROOT"/subdir/subsubdir
echo "__ciao__" > "$ROOT"/subdir/subsubdir/ciao.md
mkdir "$ROOT"docs
echo "latextest.feb-dev.net" > "$ROOT"/docs/CNAME
echo "<h1>Hallo</h1><p>no content</p>" > "$ROOT"/docs/index.html
