#!/bin/bash

set -u

export BIN="$( readlink -f -- "$( dirname -- "$0" )" )"

CONFIG=$BIN/config.sh
if [[ ! -s $CONFIG ]]; then
  echo Cannot find CONFIG \"$CONFIG\"
  exit
fi

source $CONFIG

PROG=$(basename $0 ".sh")
PBSOUT_DIR="$BIN/pbs-out/$PROG"

init_dirs "$PBSOUT_DIR" 

if [[ ! -d $FASTA_DIR ]]; then
  echo Bad FASTA_DIR \"$FASTA_DIR\"
  exit
fi

export FILES_LIST="$HOME/$$.in"
find $FASTA_DIR -type f > $FILES_LIST

NUM_FILES=$(lc $FILES_LIST)

if [[ $NUM_FILES -lt 1 ]]; then
  echo Can find no files in FASTA_DIR \"$FASTA_DIR\"
  exit
fi

echo Found NUM_FILES \"$NUM_FILES\" in \"$FASTA_DIR\"

EMAIL_ARG=''
if [[ -n $PBS_EMAIL ]]; then
  EMAIL_ARG="-M $PBS_EMAIL -m ea"
fi

GROUP_ARG="-W group_list=${PBS_GROUP:-bhurwitz}"

SCRIPT=$WORKER_DIR/fa-split.sh

if [[ ! -e $SCRIPT ]]; then
  echo Cannot find SCRIPT \"$SCRIPT\";
  exit
fi

echo Submitting SCRIPT \"$SCRIPT\"

export SPLIT_SIZE=50000

JOB=$(qsub -v BIN_DIR,SCRIPT_DIR,WORKER_DIR,BIN,FILES_LIST,SPLIT_DIR,SPLIT_SIZE -N split-fa -j oe -o "$PBSOUT_DIR" "$GROUP_ARG" "$SCRIPT")

if [ $? -eq 0 ]; then
  echo Submitted job \"$JOB.\" Long live Flash.
else
  echo -e "\nError submitting job\n$JOB\n"
fi
