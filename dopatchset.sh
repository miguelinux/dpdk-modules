#!/bin/bash

LVER=linux-4.2.y
REPO=$(mktemp -d)

git -C ${REPO} init
mkdir ${REPO}/drivers/net

# Get Kconfig & Makefile from kernel
git checkout ${LVER} drivers/net/Kconfig drivers/net/Makefile
# Copy them to new repo
cp drivers/net/Kconfig drivers/net/Makefile ${REPO}/drivers/net
# Restore them
git reset HEAD drivers/net/Kconfig drivers/net/Makefile
git checkout drivers/net/Kconfig drivers/net/Makefile

git -C ${REPO} add --all
git -C ${REPO} commit -s -m "${LVER} Makefile & Kconfig"

# Copy dpdk sources
cp -r  drivers/net/dpdk ${REPO}/drivers/net
git -C ${REPO} add --all
git -C ${REPO} commit -s -m "Add DPDK source files"

cp drivers/net/Kconfig drivers/net/Makefile ${REPO}/drivers/net
git -C ${REPO} add --all
git -C ${REPO} commit -s -m "Integrate Kconfig and Makefiles"

git -C ${REPO} format-pach --start-number 5001 -2

