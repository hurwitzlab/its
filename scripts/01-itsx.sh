#!/bin/bash

set -u

export BIN="$( readlink -f -- "$( dirname -- "$0" )" )"

export CONFIG=$BIN/config.sh
if [[ ! -s $CONFIG ]]; then
  echo Cannot find CONFIG \"$CONFIG\"
  exit
fi

source $CONFIG

PROG=$(basename $0 ".sh")
PBSOUT_DIR="$BIN/pbs-out/$PROG"

init_dirs "$PBSOUT_DIR" 

if [[ ! -d $SPLIT_DIR ]]; then
  echo Bad SPLIT_DIR \"$SPLIT_DIR\"
  exit
fi

export FILES_LIST="$HOME/$$.in"
find $SPLIT_DIR -type f > $FILES_LIST

NUM_FILES=$(lc $FILES_LIST)

if [[ $NUM_FILES -lt 1 ]]; then
  echo Can find no files in SPLIT_DIR \"$SPLIT_DIR\"
  exit
fi

echo Found NUM_FILES \"$NUM_FILES\" in \"$SPLIT_DIR\"

EMAIL_ARG=''
if [[ -n $PBS_EMAIL ]]; then
  EMAIL_ARG="-M $PBS_EMAIL -m ea"
fi

GROUP_ARG="-W group_list=${PBS_GROUP:-bhurwitz}"

SCRIPT=$WORKER_DIR/itsx.sh

if [[ ! -e $SCRIPT ]]; then
  echo Cannot find SCRIPT \"$SCRIPT\";
  exit
fi

if [[ ! -d $ITSX_DIR ]]; then
  mkdir -p $ITSX_DIR
fi

echo Submitting SCRIPT \"$SCRIPT\"

JOB=$(qsub -J 1-$NUM_FILES -v CONFIG,BIN_DIR,BIN,FILES_LIST,ITSX_DIR -N itsx -j oe -o "$PBSOUT_DIR" "$GROUP_ARG" "$SCRIPT")

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB.\" Long live Flash.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
