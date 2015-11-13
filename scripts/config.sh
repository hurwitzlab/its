# --------------------------------------------------
#
# config.sh
# 
# Edit this file to match your directory structure
#
# --------------------------------------------------

# 
# Where we can find all our custom binaries (e.g., jellyfish)
# 
export BIN_DIR=/rsgrps/bhurwitz/hurwitzlab/bin
export ITSX=$BIN_DIR/ITSx

export PBS_EMAIL=kyclark@email.arizona.edu

export PBS_GROUP=mbsulli

export BASE_DIR=/rsgrps/bhurwitz/kyclark/its
export DATA_DIR=$BASE_DIR/data
export FASTA_DIR=$DATA_DIR/fasta
export ITSX_DIR=$DATA_DIR/itsx
export SPLIT_DIR=$DATA_DIR/split
export SCRIPT_DIR=$BASE_DIR/scripts
export WORKER_DIR=$BASE_DIR/scripts/workers

#
# Some custom functions for our scripts
#
# --------------------------------------------------
function init_dirs {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}

# --------------------------------------------------
function lc() {
    wc -l $1 | cut -d ' ' -f 1
}

# --------------------------------------------------
function get_lines() {
 FILE=$1
 OUT_FILE=$2
 START=${3:-1}
 STEP=${4:-1}

 if [ -z $FILE ]; then
   echo No input file
   exit 1
 fi

 if [ -z $OUT_FILE ]; then
   echo No output file
   exit 1
 fi

 if [[ ! -e $FILE ]]; then
   echo Bad file \"$FILE\"
   exit 1
 fi

 awk "NR==$START,NR==$(($START + $STEP - 1))" $FILE > $OUT_FILE
}
