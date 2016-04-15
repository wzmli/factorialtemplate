#!/bin/bash
source ./.myhpc
cat > $2 <<EOF
#!/bin/bash
#PBS -r y
#PBS -N $3
#PBS -o $3.o
#PBS -e $3.err
#PBS -m $PBSNOTIFICATIONS
#PBS -M $PBSEMAIL
#PBS -l walltime=$WALLTIME
#PBS -l nodes=$NODES:ppn=$CORES
#PBS -l pmem=$PMEM
#PBS -t 1-$4

$MODS cd $PBSWD
invoke=\`cat $1 | tail -n +\$PBS_ARRAYID | head -1\`
\$invoke
EOF
