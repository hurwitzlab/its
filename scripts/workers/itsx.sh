#PBS -N ITSx
#PBS -q standard
#PBS -l select=1:ncpus=12:mem=23Gb
#PBS -l cput=360:0:0
#PBS -l walltime=30:0:0
#PBS -l jobtype=htc_only
#PBS -l pvmem=23Gb

set -u

module load perl

module load hmmer

if [[ -n $CONFIG ]]; then
  source $CONFIG
fi

if [[ -n $BIN_DIR ]]; then
  PATH=$BIN_DIR:$PATH
fi

if [[ -z $FILES_LIST ]]; then
  echo FILES_LIST not defined
  exit
fi

if [[ ! -s $FILES_LIST ]]; then
  echo Bad FILES_LIST \"$FILES_LIST\"
  exit
fi

TMP_FILES=$(mktemp)

get_lines $FILES_LIST $TMP_FILES ${PBS_ARRAY_INDEX:-1} ${STEP_SIZE:-1}

NUM_FILES=$(lc $TMP_FILES)

if [[ $NUM_FILES -lt 1 ]]; then
  echo Found no files in $FILES_LIST to process
  exit
fi

# -t F selects fungi (default is all), --preserve preserves sequence headers from input
i=0
while read FILE; do
  let i++
  printf "%5d: %s\n" $i $(basename $FILE)
  perl $ITSX -i $FILE -N 1 -t F --preserve T -E 1e-1 --anchor HMM \
    --save_regions all -o $ITSX_DIR/$(basename $FILE)
done < $TMP_FILES

echo Done.
