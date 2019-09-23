#!/bin/sh

# General 
export ADVC_DIR="${HOME}/apps/Solver-2019R1_0r19/bin"
export ALDE_LICENSE_FILE=27000@<IPAddress>

# Platform MPI
export MPI_HASIC_UDAPL=ofa-v2-ib0

# Intel MPI
export MPI_ROOT="/opt/intel/impi/2018.4.274"
export I_MPI_ROOT=$MPI_ROOT
export I_MPI_DEBUG=9
export I_MPI_FABRICS=shm:ofa # for 2019, use I_MPI_FABRICS=shm:ofi
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HOME}/apps/Solver-2019R1_0r19/user_lib
source /opt/intel/compilers_and_libraries/linux/mpi/bin64/mpivars.sh
