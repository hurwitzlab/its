#PBS -N fa-split
#PBS -q standard
#PBS -l select=1:ncpus=12:mem=23Gb
#PBS -l cput=360:0:0
#PBS -l walltime=30:0:0
#PBS -l jobtype=htc_only
#PBS -l pvmem=23Gb

if [[ -z $SPLIT_DIR ]]; then
  echo SPLIT_DIR not defined.
  exit
fi

if [[ ! -d $SPLIT_DIR ]]; then
  mkdir -p $SPLIT_DIR
fi

if [[ -n $BIN_DIR ]]; then
  PATH=$BIN_DIR:$PATH
fi

SPLITTER=$SCRIPT_DIR/fasta-splitter.pl
if [[ ! -e $SPLITTER ]]; then
  echo Cannot find SPLITTER \"$SPLITTER\"
  exit
fi

if [[ -z $FILES_LIST ]]; then
  echo FILES_LIST \"$FILES_LIST\" not defined.
  exit
fi

if [[ ! -s $FILES_LIST ]]; then
  echo Bad FILES_LIST \"$FILES_LIST\" 
  exit
fi

while read FASTA; do
  $SPLITTER -n ${SPLIT_SIZE:-100000} -o $SPLIT_DIR $FASTA
done < $FILES_LIST
