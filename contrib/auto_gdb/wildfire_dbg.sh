#!/bin/bash
# use testnet settings,  if you need mainnet,  use ~/.wildfirecore/wildfired.pid file instead
wildfire_pid=$(<~/.wildfirecore/testnet3/wildfired.pid)
sudo gdb -batch -ex "source debug.gdb" wildfired ${wildfire_pid}
