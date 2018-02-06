#!/bin/bash
export DEST="./.exvim.newApp"
export TOOLS="/home/nicoer/exvim//vimfiles/tools/"
export CSCOPE_CMD="cscope"
export OPTIONS="-kb -i"
export TMP="${DEST}/_cscope.out"
export TARGET="${DEST}/cscope.out"
sh ${TOOLS}/shell/bash/update-cscope.sh
