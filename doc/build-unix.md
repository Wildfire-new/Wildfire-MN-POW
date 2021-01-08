UNIX BUILD NOTES
====================
Some notes on how to build Wildfire Core in Unix.

(for OpenBSD specific instructions, see [build-openbsd.md](build-openbsd.md))

Base build dependencies
-----------------------
Building the dependencies and Wildfire Core requires some essential build tools and libraries to be installed before.

Run the following commands to install required packages:

##### Debian/Ubuntu:
```bash 
$ sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 curl libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libboost-all-dev libboost-program-options-dev libminiupnpc-dev libzmq3-dev libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev unzip doxygen cmake libgmp3-dev
```

Swappfile
```
 dd if=/dev/zero of=/var/swapfile bs=2048 count=1048576
    mkswap /var/swapfile
    swapon /var/swapfile
    chmod 0600 /var/swapfile
    chown root:root /var/swapfile
    echo "/var/swapfile none swap sw 0 0" >> /etc/fstab
```
Install Berkeley DB.

```
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install libdb4.8-dev libdb4.8++-dev
```
```
$ chmod +x configure libtool autogen.sh
$ cd depends
$chmod +x config.guess config.sub
$ cd share
$ chmod 755 genbuild.sh
$ ./autogen.sh 
$ ./configure --prefix=pwd/depends/<host>
$ make
$ make install # optional
Please replace <host> with your local system's host-platform-triplet. The following triplets are usually valid:

i686-pc-linux-gnu for Linux32
x86_64-pc-linux-gnu for Linux64
i686-w64-mingw32 for Win32
x86_64-w64-mingw32 for Win64
x86_64-apple-darwin11 for MacOSX
arm-linux-gnueabihf for Linux ARM 32 bit
aarch64-linux-gnu for Linux ARM 64 bit
```

##### Fedora:
```bash
$ sudo dnf install gcc-c++ libtool make autoconf automake python3 cmake libstdc++-static patch
```

##### Arch Linux:
```bash
$ pacman -S base-devel python3 cmake
```

##### FreeBSD/OpenBSD:
```bash
pkg_add gmake cmake libtool
pkg_add autoconf # (select highest version, e.g. 2.69)
pkg_add automake # (select highest version, e.g. 1.15)
pkg_add python # (select highest version, e.g. 3.5)
```

Building
--------

Follow the instructions in [build-generic](build-generic.md)

Security
--------
To help make your Wildfire installation more secure by making certain attacks impossible to
exploit even if a vulnerability is found, binaries are hardened by default.
This can be disabled with:

Hardening Flags:

	./configure --prefix=<prefix> --enable-hardening
	./configure --prefix=<prefix> --disable-hardening


Hardening enables the following features:

* Position Independent Executable
    Build position independent code to take advantage of Address Space Layout Randomization
    offered by some kernels. Attackers who can cause execution of code at an arbitrary memory
    location are thwarted if they don't know where anything useful is located.
    The stack and heap are randomly located by default but this allows the code section to be
    randomly located as well.

    On an AMD64 processor where a library was not compiled with -fPIC, this will cause an error
    such as: "relocation R_X86_64_32 against `......' can not be used when making a shared object;"

    To test that you have built PIE executable, install scanelf, part of paxutils, and use:

    	scanelf -e ./wildfired

    The output should contain:

     TYPE
    ET_DYN

* Non-executable Stack
    If the stack is executable then trivial stack based buffer overflow exploits are possible if
    vulnerable buffers are found. By default, Wildfire Core should be built with a non-executable stack
    but if one of the libraries it uses asks for an executable stack or someone makes a mistake
    and uses a compiler extension which requires an executable stack, it will silently build an
    executable without the non-executable stack protection.

    To verify that the stack is non-executable after compiling use:
    `scanelf -e ./wildfired`

    the output should contain:
	STK/REL/PTL
	RW- R-- RW-

    The STK RW- means that the stack is readable and writeable but not executable.

Disable-wallet mode
--------------------
When the intention is to run only a P2P node without a wallet, Wildfire Core may be compiled in
disable-wallet mode with:

    ./configure --prefix=<prefix> --disable-wallet

In this case there is no dependency on Berkeley DB 4.8.

Mining is also possible in disable-wallet mode, but only using the `getblocktemplate` RPC
call not `getwork`.

Additional Configure Flags
--------------------------
A list of additional configure flags can be displayed with:

    ./configure --help

Building on FreeBSD
--------------------

(TODO, this is untested, please report if it works and if changes to this documentation are needed)

Building on FreeBSD is basically the same as on Linux based systems, with the difference that you have to use `gmake`
instead of `make`.

*Note on debugging*: The version of `gdb` installed by default is [ancient and considered harmful](https://wiki.freebsd.org/GdbRetirement).
It is not suitable for debugging a multi-threaded C++ program, not even for getting backtraces. Please install the package `gdb` and
use the versioned gdb command e.g. `gdb7111`.

Building on OpenBSD
-------------------

(TODO, this is untested, please report if it works and if changes to this documentation are needed)
(TODO, clang might also be an option. Old documentation reported it to to not work due to linking errors, but we're building all dependencies now as part of the depends system, so this might have changed)

Building on OpenBSD might require installation of a newer GCC version. If needed, do this with:

```bash
$ pkg_add g++ # (select newest 6.x version)
```

This compiler will not overwrite the system compiler, it will be installed as `egcc` and `eg++` in `/usr/local/bin`.

Add `CC=egcc CXX=eg++ CPP=ecpp` to the dependencies build and the Wildfire Core build:
```bash
$ cd depends
$ make CC=egcc CXX=eg++ CPP=ecpp # do not use -jX, this is broken
$ cd ..
$ export AUTOCONF_VERSION=2.69 # replace this with the autoconf version that you installed
$ export AUTOMAKE_VERSION=1.15 # replace this with the automake version that you installed
$ ./autogen.sh
$ ./configure --prefix=<prefix> CC=egcc CXX=eg++ CPP=ecpp
$ gmake # do not use -jX, this is broken
```

Building PI-Qt Wallet

Install the required dependencies.
```
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev libboost-all-dev libboost-program-options-dev
sudo apt-get install libminiupnpc-dev libzmq3-dev libprotobuf-dev protobuf-compiler unzip software-properties-common
```
Install Berkeley DB from source code.
```
wget https://download.oracle.com/berkeley-db/db-4.8.30.zip
unzip db-4.8.30.zip
cd db-4.8.30
cd build_unix/
../dist/configure --prefix=/usr/local --enable-cxx
make
sudo make install
```
```
wget https://fukuchi.org/works/qrencode/qrencode-4.0.0.tar.gz
tar zxvf qrencode-4.0.0.tar.gz
cd qrencode-4.0.0/
./configure
make
sudo make install
sudo ldconfig

sudo apt install libssl1.0-dev
```
Configure environment variable.
```
export LD_LIBRARY_PATH="/usr/local/lib"
```
Open your wallet, and make sure your wallet is connected with a node.
Your wallet is connected when you see the icon Wallet connections X11 in the lower right corner of your wallet.

The message “Syncing Headers (0,0%)” will disappear once you mine your first block.

Close your wallet and create the file wildfire.conf in the folder “$HOME/.wildfire/”.

Paste the following text into wildfire.conf and save the file.
```
rpcuser=rpc_wildfire
rpcpassword=242330dec2e672403a85b387c
rpcallowip=127.0.0.1
rpcport=25571
listen=1
server=1
```
