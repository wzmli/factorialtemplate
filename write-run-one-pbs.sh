#!/bin/bash
source ./.myhpc
cat > $1 <<EOF
#!/bin/bash
#PBS -r y
#PBS -N $2
#PBS -o $2.o
#PBS -e $2.err
#PBS -m $PBSNOTIFICATIONS
#PBS -M $PBSEMAIL
#PBS -l walltime=$WALLTIME
#PBS -l nodes=$NODES:ppn=$CORES
#PBS -l pmem=$PMEM
#PBS -t 1-$3

$MODS cd $PBSWD
tar=\$(printf 'results/$2.%03d.out' \$PBS_ARRAYID)
make \$tar
EOF
