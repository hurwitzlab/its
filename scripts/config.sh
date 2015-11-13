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

export PBS_EMAIL=kyclark@email.arizona.edu

export PBS_GROUP=mbsulli

export BASE_DIR=/rsgrps/bhurwitz/kyclark/its
export DATA_DIR=$BASE_DIR/data
export FASTA_DIR=$DATA_DIR/fasta
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
