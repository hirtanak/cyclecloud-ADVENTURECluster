#!/bin/bash
NODES=`cat ~/NODES`
NP=`cat ~/NP`
#PBS -j oe
#PBS -l select=${NODES}:ncpus=15

ADVC_DIR="/shared/home/azureuser/apps/Solver-2018-R1_0/bin"
MPI_ROOT="/shared/home/azureuser/apps/Solver-2018-R1_0/platform_mpi/bin"
INPUT="/shared/home/azureuser/model_v2.adx"
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/shared/home/azureuser/apps/Solver-2018-R1_0/user_lib

cd ${PBS_O_WORKDIR}

${ADVC_DIR}/ADVCSolver ${INPUT} -out-dir ~/ -np ${NP} | tee ADVC-`date +%Y%m%d_%H-%M-%S`.log
