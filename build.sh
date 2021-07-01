#!/bin/bash

# Check for correct # of arguments
if test "$#" -ne 3; then
	echo "Usage: ./build.sh <path-to-fiesta-clone> <commit-hash> <env-file-to-source>"
	exit 1
fi

# Collect arguments and set variables
export PROJROOT=$1
export COMMIT=$2
export ENV=$3

# Setup environment
. ${ENV} || exit 1
module list

# Git
cd ${PROJROOT}
git checkout ${COMMIT} || exit 1

# CMake
export BDIR=build-$(basename ${ENV})-${COMMIT}
rm -vrf ./${BDIR}
mkdir -p ./${BDIR}
cd ${BDIR}
printenv

if [[ $ENV == *"lassen"* ]]; then
	cmake .. -DCUDA=ON\
	 -DMPI_ASSUME_NO_BUILTIN_MPI=ON\
	 -DMPI_C_COMPILER=mpicc\
	 -DMPI_CXX_COMPILER=mpicxx\
	 -DMPI_Fortran_COMPILER=mpif90\
	 -DKokkos_ARCH_VOLTA70=ON\
	 && make -j8
else
	cmake .. -DCUDA=ON && make -j8
fi
