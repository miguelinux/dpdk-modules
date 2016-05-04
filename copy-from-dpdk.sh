#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh nu
#

DPDK=$1

if [ -z "$DPDK" ] ; then
    echo "Missing first argument to know where DPDK is"
    exit 1;
fi

DPDK_EAL=${DPDK}/lib/librte_eal
#Kernel DPDK
KD=drivers/net/dpdk

mkdir -p ${KD}

for f in rte_pci_dev_feature_defs.h  rte_pci_dev_features.h
do
    cp ${DPDK_EAL}/common/include/${f} ${KD}
done

cp ${DPDK_EAL}/linuxapp/igb_uio/igb_uio.c ${KD}
cp ${DPDK_EAL}/linuxapp/igb_uio/compat.h ${KD}

