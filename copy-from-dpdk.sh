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
mkdir -p ${KD}/kni
mkdir -p ${KD}/kni/exec-env

for f in rte_pci_dev_feature_defs.h  rte_pci_dev_features.h
do
    cp ${DPDK_EAL}/common/include/${f} ${KD}
done

cp ${DPDK_EAL}/linuxapp/igb_uio/igb_uio.c ${KD}
cp ${DPDK_EAL}/linuxapp/igb_uio/compat.h ${KD}

cp ${DPDK_EAL}/common/include/rte_pci_dev_ids.h ${KD}/kni
cp ${DPDK_EAL}/linuxapp/eal/include/exec-env/rte_kni_common.h ${KD}/kni/exec-env

sed -i "s/RTE_CACHE_LINE_SIZE/CONFIG_DPDK_CACHE_LINE_SIZE/g" ${KD}/kni/exec-env/rte_kni_common.h

cp ${DPDK_EAL}/linuxapp/kni/*.c ${KD}/kni
cp ${DPDK_EAL}/linuxapp/kni/*.h ${KD}/kni

#
for f in ${KD}/kni/*.h ${KD}/kni/*.c
do
    sed -i "s/RTE_KNI_PREEMPT_DEFAULT/CONFIG_DPDK_KNI_PREEMPT_DEFAULT/g" $f;
    sed -i "s/RTE_KNI_KO_DEBUG/CONFIG_DPDK_KNI_KO_DEBUG/g" $f;
    sed -i "s/RTE_KNI_VHOST/CONFIG_DPDK_KNI_VHOST/g" $f;
#    sed -i "s/RTE_KNI_VHOST_VNET_HDR_EN/CONFIG_DPDK_KNI_VHOST_VNET_HDR_EN/g" $f;
#    sed -i "s/RTE_KNI_VHOST_DEBUG_RX/CONFIG_DPDK_KNI_VHOST_DEBUG_RX/g" $f;
#    sed -i "s/RTE_KNI_VHOST_DEBUG_TX/CONFIG_DPDK_KNI_VHOST_DEBUG_TX/g" $f;
done

cp ${DPDK_EAL}/linuxapp/kni/ethtool/igb/*.h ${KD}/kni
cp ${DPDK_EAL}/linuxapp/kni/ethtool/igb/kcompat.h ${KD}/kni/kcompat_igb.h
cp ${DPDK_EAL}/linuxapp/kni/ethtool/igb/*.c ${KD}/kni

for f in ${KD}/kni/igb.h ${KD}/kni/e1000_osdep.h
do
    sed -i "s/kcompat.h/kcompat_igb.h/g" $f;
done

cp ${DPDK_EAL}/linuxapp/kni/ethtool/ixgbe/*.h ${KD}/kni
cp ${DPDK_EAL}/linuxapp/kni/ethtool/ixgbe/*.c ${KD}/kni

# Remove unneeded file
rm ${KD}/kni/igb_ptp.c
rm ${KD}/kni/kcompat.c
