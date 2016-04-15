#!/usr/bin/bash
source ./.myhpc
echo "wall time (hhh:mm:ss, with hs and ms optional)?"
read WALLTIME
echo "nodes? (per individual array job, not for the whole job)"
read NODES
echo "cores? (per node [per array job], not for the whole job)"
read CORES
echo "process memory? (per core [again, not for the whole thing])"
read PMEM
echo "modules (i.e. gcc/VERSION R/VERSION)? [enter all on one line, or enter for no modules]"
read MODS
if [ -z $MODS ] then
  MODS=module load $MODS
fi

cat > $1 <<EOF
#!/bin/bash
#PBS -r y
#PBS -N $JOBNAME
#PBS -o $JOBNAME.o
#PBS -e $JOBNAME.err
#PBS -m $PBSNOTIFICATIONS
#PBS -M $PBSEMAIL
#PBS -l walltime=$WALLTIME
#PBS -l nodes=$NODES:ppn=$CORES
#PBS -l pmem=$PMEM
#PBS -t 1-$4

$MODS
cd $PBSWD
tar=\$(printf 'results/$3/%03d.rds' \$PBS_ARRAYID)
make \$tar
EOF
