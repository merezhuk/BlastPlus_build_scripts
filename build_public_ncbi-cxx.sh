#!/bin/sh
#
# This script builds Blast+ binaries for Apple hardware from current public GitHub repository
# GITSRC
# 
# List of binaries specified in TARGETS2BUILD
# 
GITSRC="https://github.com/ncbi/ncbi-cxx-toolkit-public.git ncbi-cxx-toolkit-public"

TARGETS2BUILD="blastn;blastp;blastx;tblastn;tblastx;blastdbcmd;blast_formatter;"

# #######################################################
if [ "X$1" = "X-h" ] ; then
	echo "########################################################################################"
	echo "# $0"
	echo "# This script builds Blast+ binaries for Apple hardware from current public GitHub repository"
	echo "# Current list of binaries: ${TARGETS2BUILD}"
	echo "# GITSRC: ${GITSRC} "
	echo "#                                                                                     "
	echo "# usage: $0"
	echo "#######################################################################################"
	exit 0
fi
# #######################################################
#1 
echo "STEP 1: gettings source code from GitHub..."
if [ ! -d ncbi-cxx-toolkit-public ] ; then
git clone ${GITSRC} 
else
	echo "INFO: source code already checked out: ./ncbi-cxx-toolkit-public use it."
fi
if [ ! -d ncbi-cxx-toolkit-public ] ; then
	echo "ERROR: can't check out NCBI CXX toolkit source code."
	exit 1
fi
echo "STEP 1: got NCBI CXX source code."

#2 
echo "STEP 2: check cmake..."
cmake -help 2>1 1>/dev/null
if [ $? != 0  ] ; then
	echo "ERROR: please install cmake"
	exit 1
fi
echo "STEP 2: cmake found."

#3
echo "STEP 3: configure source tree..."
cd ncbi-cxx-toolkit-public 
./cmake-configure --without-debug --without-dll --with-targets="${TARGETS2BUILD}"
echo "STEP 3: configure done."

#4
echo "STEP 4: build targets..."
cd CMake-Clang*-Release/build && make 

#4
echo "STEP: list ready applications"
echo "DEBUG: CWD: "`pwd`
# DEBUG: CWD: /Users/zuk/work/TAO_BUILD_TEST/ncbi-cxx-toolkit-public/CMake-Clang1403-Release/build
#ls -l CMake-Clang*-Release/bin
cd ../..
ls -l CMake-Clang*-Release/bin
file CMake-Clang*-Release/bin/*
