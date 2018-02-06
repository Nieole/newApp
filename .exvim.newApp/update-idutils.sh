#!/bin/bash
export DEST="./.exvim.newApp"
export TOOLS="/home/nicoer/exvim//vimfiles/tools/"
export TMP="${DEST}/_ID"
export TARGET="${DEST}/ID"
sh ${TOOLS}/shell/bash/update-idutils.sh
