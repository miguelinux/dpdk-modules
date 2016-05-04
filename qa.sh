#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#

DPDK=$1
DPDK_EAL=${DPDK}/lib/librte_eal
#Kernel DPDK
KD=drivers/net/dpdk
LF=/tmp/dpdk-log

# Be sure we are in master
git checkout master

# Delete previoes Q/A branch
git branch -D qa

# Create new branch to do QA
git checkout -b qa master


if [ -d /usr/share/clear/bundles ] ; then
    GIT=gitp
else
    GIT=git
fi
# Pull the lastes DPDK repo
echo $GIT -C ${DPDK} pull
$GIT -C ${DPDK} pull


for f in rte_pci_dev_feature_defs.h  rte_pci_dev_features.h
do
    cp ${DPDK_EAL}/common/include/${f} ${KD}
done

cp ${DPDK_EAL}/linuxapp/igb_uio/igb_uio.c ${KD}

cp ${DPDK_EAL}/common/include/rte_pci_dev_ids.h ${KD}/kni
cp ${DPDK_EAL}/linuxapp/eal/include/exec-env/rte_kni_common.h ${KD}/kni

cp ${DPDK_EAL}/linuxapp/kni/*.c ${KD}/kni
cp ${DPDK_EAL}/linuxapp/kni/*.h ${KD}/kni

cp ${DPDK_EAL}/linuxapp/kni/ethtool/igb/*.h ${KD}/kni
cp ${DPDK_EAL}/linuxapp/kni/ethtool/igb/*.c ${KD}/kni
cp ${DPDK_EAL}/linuxapp/kni/ethtool/igb/kcompat.h ${KD}/kni/kcompact_igb.h

cp ${DPDK_EAL}/linuxapp/kni/ethtool/ixgbe/*.h ${KD}/kni
cp ${DPDK_EAL}/linuxapp/kni/ethtool/ixgbe/*.c ${KD}/kni

# Not included in Makefile
rm ${KD}/kni/igb_ptp.c
# Nobody uset them
rm ${KD}/kni/kcompact_igb.h
rm ${KD}/kni/kcompat_ethtool.c
# Refactor to not use it
rm ${KD}/kni/compat.h

git add -A
git commit -m "QA copy"

# Change to master
git checkout master

