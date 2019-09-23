#!/bin/bash
# Copyright (c) 2019 Hiroshi Tanaka, hirtanak@gmail.com @hirtanak
set -exuv

echo "starting 10.master.sh"

# disabling selinux
echo "disabling selinux"
setenforce 0
sed -i -e "s/^SELINUX=enforcing$/SELINUX=disabled/g" /etc/selinux/config

CUSER=$(grep "Added user" /opt/cycle/jetpack/logs/jetpackd.log | awk '{print $6}')
CUSER=${CUSER//\'/}
CUSER=${CUSER//\`/}
echo ${CUSER} > /mnt/exports/shared/CUSER
HOMEDIR=/shared/home/${CUSER}
CYCLECLOUD_SPEC_PATH=/mnt/cluster-init/ADVENTURECluster/master

# get file name
ADVCFILENAME=$(jetpack config ADVCFileName)
# set ADVC version
ADVC_VERSION=$(echo $ADVCFILENAME | awk -F'-' '{print $2}')
ADVC_VERSION2=${ADVC_VERSION/./_}
ADVC_PLATFORM=$(echo $ADVCFILENAME | awk -F'-' '{print $4}')
ADVC_PLATFORM=${ADVC_PLATFORM%.tar.gz}

if [[ "`echo ${ADVC_PLATFORM} | grep platform_mpi`" ]] ; then
  MPI_PLATFORM=platform_mpi
else
  MPI_PLATFORM=intel_mpi
fi

# Create tempdir
tmpdir=$(mktemp -d)
pushd $tmpdir

# resource ulimit setting
CMD1=$(grep memlock ${HOMEDIR}/.bashrc | head -2)
if [[ -z "${CMD1}" ]]; then
   (echo "ulimit -m unlimited") >> ${HOMEDIR}/.bashrc
fi

# License Port Setting
LICENSE=$(jetpack config LICENSE)
(echo "export ALDE_LICENSE_FILE=${LICENSE}") > /etc/profile.d/advc.sh
chmod +x /etc/profile.d/advc.sh
chown ${CUSER}:${CUSER} /etc/profile.d/advc.sh
CMD2=$(grep ALDE_LICENSE_FILE ${HOMEDIR}/.bashrc) | exit 0 
set +u
if [[ -z "${CMD2}" ]]; then
   (echo ""export ALDE_LICENSE_FILE=${LICENSE}"") >> ${HOMEDIR}/.bashrc
fi
set -u

# packages
yum install -y htop

# Create Application Dirctory
if [ ! -d ${HOMEDIR}/apps ]; then
   sudo -u ${CUSER} ln -s /mnt/exports/apps ${HOMEDIR}/apps
   chown ${CUSER}:${CUSER} /mnt/exports/apps
fi
chown ${CUSER}:${CUSER} /mnt/exports/apps | exit 0


# Installation
if [ ! -d ${HOMEDIR}/apps/Solver-${ADVC_VERSION} ]; then
   jetpack download "${ADVCFILENAME}" ${HOMEDIR}/apps
fi
chown ${CUSER}:${CUSER} ${HOMEDIR}/apps/${ADVCFILENAME}
tar zxfp ${HOMEDIR}/apps/${ADVCFILENAME} -C ${HOMEDIR}/apps 
chown -R ${CUSER}:${CUSER} ${HOMEDIR}/apps/Solver-${ADVC_VERSION2}

# download standard models
TESTMODELFILE=advcsolver_test_v2-20140929.tar.gz
if [ ! -d ${HOMEDIR}/apps/advcsolver_test_v2 ]; then
   jetpack download "${TESTMODELFILE}" ${HOMEDIR}/apps | exit 0 
fi
chown ${CUSER}:${CUSER} ${HOMEDIR}/apps/${TESTMODELFILE} | exit 0
tar zxfp ${HOMEDIR}/apps/${TESTMODELFILE} -C ${HOMEDIR}/apps | exit 0                              


# set up user files
if [ ! -f ${HOMEDIR}/advcsetup.sh ]; then
   cp ${CYCLECLOUD_SPEC_PATH}/files/advcsetup.sh ${HOMEDIR}
fi
chmod a+rx ${HOMEDIR}/advcsetup.sh
chown ${CUSER}:${CUSER} ${HOMEDIR}/advcsetup.sh

if [ ! -f ${HOMEDIR}/advcrun.sh ]; then
   cp ${CYCLECLOUD_SPEC_PATH}/files/advcrun.sh ${HOMEDIR}
fi
chmod a+rx ${HOMEDIR}/advcrun.sh
chown ${CUSER}:${CUSER} ${HOMEDIR}/advcrun.sh

#clean up
popd
rm -rf $tmpdir

echo "end of 10.master.sh"
