#!/bin/sh

ADVENTURECLUSTER_VERSION=$(jetpack config ADVENTURECluster.version)
exprot ALDE_LICENSE_FILE=$(jetpack config LICENSE)
export PATH=$PATH:~/apps/Solver-2018-R1_0/bin
export MPI_HASIC_UDAPL=ofa-v2-ib0

