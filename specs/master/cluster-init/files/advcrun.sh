#!/bin/bash
#PBS -j oe
#PBS -l select=2:ncpus=44
NP=88

## Platform MPI
#MPI_ROOT="/shared/home/azureuser/apps/Solver-2018-R1_3/platform_mpi/bin"
#export MPI_HASIC_UDAPL=ofa-v2-ib0
#export MPI_IB_PKEY="0x8008"

#disable source comamnd in advc-solver.conf
sed -i -e "s/^source/#source/g" ${HOME}/apps/Solver-2019R1_0r19/etc/advc-solver.conf

#Geneeal settings
export ADVC_DIR="/shared/home/azureuser/apps/Solver-2019R1_0r19/bin"
export ALDE_LICENSE_FILE=27000@<IPAddress>

# MPI settings
export MPI_ROOT="/opt/intel/impi/2018.4.274"
export I_MPI_ROOT=$MPI_ROOT
export I_MPI_DEBUG=9
export I_MPI_FABRICS=shm:ofa # for 2019, use I_MPI_FABRICS=shm:ofi
# H16r 
#export I_MPI_FABRICS=shm:dapl
#export I_MPI_DAPL_PROVIDER=ofa-v2-ib0
#export I_MPI_DYNAMIC_CONNECTION=0
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/shared/home/azureuser/apps/Solver-2019R1_0r19/user_lib
source /opt/intel/compilers_and_libraries/linux/mpi/bin64/mpivars.sh

# running config
INPUT=/mnt/exports/shared/home/azureuser/model_v2.adv

cd ${PBS_O_WORKDIR}
${ADVC_DIR}/ADVCSolver ${INPUT} -np ${NP} | tee ADVC-`date +%Y%m%d_%H-%M-%S`.log
