#!/bin/bash

ROOT="$1"/
echo "new website: '$ROOT'"
echo "hallo abc" > "$ROOT"/hallo.txt
mkdir "$ROOT"subdir
echo "bye abc" > "$ROOT"/subdir/bye.txt
mkdir "$ROOT"/subdir/subsubdir
echo "ciao ???" > "$ROOT"/subdir/subsubdir/ciao.txt
