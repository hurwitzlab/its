#PBS -N ITSx
#PBS -m bea
#PBS -M juren@email.arizona.edu
#PBS -W group_list=fungi
#PBS -q standard
#PBS -l select=1:ncpus=12:mem=23Gb
#PBS -l cput=360:0:0
#PBS -l walltime=30:0:0
#PBS -l jobtype=htc_only
#PBS -l pvmem=23Gb

module load perl
module load hmmer
cd /rsgrps/bhurwitz/hurwitzlab/bin/

# -t F selects fungi (default is all), --preserve preserves sequence headers from input
perl ITSx -i /rsgrps/bhurwitz/hurwitzlab/data/jana/juren/data/IBEST/ITS_R1-hdr2_ee25_trunc175.fasta -N 1 -t F --preserve T -E 1e-1 --anchor HMM --save_regions all -o /rsgrps/bhurwitz/hurwitzlab/data/jana/juren/data/IBEST/ITSx/ITSx_ITS_R1-hdr2_ee25_trunc175
