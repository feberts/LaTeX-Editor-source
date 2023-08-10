#!/bin/bash

ROOT="$1"
echo "hallo abc" > "$ROOT"/hallo.txt
mkdir "$ROOT"subdir
echo "bye abc" > "$ROOT"/subdir/bye.txt
mkdir "$ROOT"/subdir/subsubdir
echo "ciao abc" > "$ROOT"/subdir/subsubdir/ciao.txt
