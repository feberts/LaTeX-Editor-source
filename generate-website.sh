#!/bin/bash

ROOT="./website_root/"
mkdir "$ROOT"
echo "hallo 123" > "$ROOT"/hallo.txt
mkdir "$ROOT"subdir
echo "bye 123" > "$ROOT"/subdir/bye.txt
mkdir "$ROOT"/subdir/subsubdir
echo "ciao 123" > "$ROOT"/subdir/subsubdir/ciao.txt
