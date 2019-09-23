#!/bin/bash
#PBS -j oe
#PBS -l nodes=2:ppn=16

ADVC_DIR="/shared/home/azureuser/apps/Solver-2018-R1_0/bin"
MPI_ROOT="/shared/home/azureuser/apps/Solver-2018-R1_0/platform_mpi/bin"
INPUT="/shared/home/azureuser/model_v2.adx"
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/shared/home/azureuser/apps/Solver-2018-R1_0/user_lib

cd ${PBS_O_WORKDIR}
NP=$(wc -l ${PBS_NODEFILE} | awk '{print $1}')
${ADVC_DIR}/ADVCSolver ${INPUT} -out-dir ~/ -np ${NP} | tee ADVC-`date +%Y%m%d_%H-%M-%S`.log
