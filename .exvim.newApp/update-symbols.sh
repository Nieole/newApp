#!/bin/bash
export DEST="./.exvim.newApp"
export TOOLS="/home/nicoer/exvim//vimfiles/tools/"
export TMP="${DEST}/_symbols"
export TARGET="${DEST}/symbols"
sh ${TOOLS}/shell/bash/update-symbols.sh
