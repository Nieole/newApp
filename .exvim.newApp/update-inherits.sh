#!/bin/bash
export DEST="./.exvim.newApp"
export TOOLS="/home/nicoer/exvim//vimfiles/tools/"
export TMP="${DEST}/_inherits"
export TARGET="${DEST}/inherits"
sh ${TOOLS}/shell/bash/update-inherits.sh
