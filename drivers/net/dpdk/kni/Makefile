#
# Makefile for the DPDK Kernel NIC Interface
#

obj-$(CONFIG_DPDK_KNI)       += rte_kni.o

rte_kni-y := ixgbe_main.o ixgbe_api.o ixgbe_common.o ixgbe_ethtool.o \
		ixgbe_82599.o ixgbe_82598.o ixgbe_x540.o ixgbe_phy.o \
		\
		e1000_82575.o e1000_i210.o e1000_api.o e1000_mac.o \
		e1000_manage.o e1000_mbx.o e1000_nvm.o e1000_phy.o \
		igb_ethtool.o igb_hwmon.o igb_main.o igb_debugfs.o igb_param.o \
		igb_procfs.o igb_vmdq.o \
		\
		kni_misc.o kni_net.o kni_ethtool.o

rte_kni-$(CONFIG_DPDK_KNI_VHOST) += kni_vhost.o
