#!/bin/sh
#
# This script builds Blast+ binaries for Apple hardware from recently released sources 
# Current version is: ${ARCH_NAME}
# Please check and be sure above file is accessible by this URL: ${LATEST_SRC} 
# and fix if not.

ARCH_NAME=`curl  --no-progress-meter https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ | grep -v md5 | grep src.tar.gz | cut -d\" -f2`
LATEST_SRC="https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/${ARCH_NAME}"

# this is list of binaries to build.  
TARGETS2BUILD="blastn;blastp;blastx;tblastn;tblastx;blastdbcmd;blast_formatter;"

DIR_NAME=`echo ${ARCH_NAME} | sed -e 's/.tar.gz//'`

# #######################################################
if [ "X$1" = "X-h" ] ; then
	echo "########################################################################################"
	echo "# $0"
	echo "# This script builds Blast+ binaries for Apple hardware from recently released sources "
	echo "# Current version is: ${ARCH_NAME}"
	echo "# Please check and be sure above file is accessible by this URL:"
	echo "# ${LATEST_SRC} "
	echo "# and fix if not."
	echo "#                                                                                     "
	echo "# usage: $0"
	echo "#######################################################################################"
	exit 0
fi
# #######################################################
#1.A
echo "STEP 1: gettings source code from ${LATEST_SRC} ..."
if [ ! -f ${ARCH_NAME} ] ; then
	curl ${LATEST_SRC} -o ${ARCH_NAME}
	if [ ! -f ${ARCH_NAME} ] ; then
		echo "ERROR: can't download from ${LATEST_SRC}"
		exit 1
	fi
else
	echo "INFO: found ${ARCH_NAME} will NOT download new archive"
fi

#1.B check presence of a unpacked archive
if [ -d ${DIR_NAME}  ] ; then
	echo "INFO: found unpacked source, will NOT unpack again"
else
	tar -zxf ${ARCH_NAME}
	if [ $? != 0  ] ; then
		echo "ERROR: while unpacking ${ARCH_NAME}"
		exit 1
	fi
	if [ ! -d ${DIR_NAME} ] ; then
		echo "ERROR: can't unpack: ${ARCH_NAME}"
		exit 1
	fi
	echo "STEP 1: INFO: sources ${ARCH_NAME} unpacked to: ${DIR_NAME}"
fi


#--------------------------------------------
#2 
echo "STEP 2: check cmake..."
cmake -help 2>1 1>/dev/null
if [ $? != 0  ] ; then
	echo "ERROR: please install cmake"
	exit 1
fi
echo "STEP 2: cmake found."

#--------------------------------------------
#3
echo "STEP 3: configure source tree..."
cd ${DIR_NAME}/c++
./src/build-system/cmake/cmake-cfg-unix.sh --without-debug    --without-dll  --with-targets="blastn;blastp;blastx;blastdbcmd;blast_formatter;datatool"
echo "STEP 3: source configuration done."

#--------------------------------------------
#4
# CMake-Clang1403-Release/build
echo "STEP 4: build targets..."
cd CMake-Clang*-Release/build && make 

echo "STEP 4: build done."
#--------------------------------------------
#5
echo "STEP 5: list ready applications"
cd ../..
ls -l CMake-Clang*-Release/bin
file CMake-Clang*-Release/bin/*

echo "STEP 6: done. "
