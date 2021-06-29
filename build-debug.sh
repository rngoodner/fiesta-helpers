#!/bin/bash

# Check for correct # of arguments
if test "$#" -ne 3; then
	echo "Usage: ./build.sh <path-to-fiesta-clone> <commit-hash> <env-type>"
	exit 1
fi

# Collect arguments and set variables
export PROJROOT=$1
export COMMIT=$2
export ENV=$3
export GCCVER=9.4.0

# Spack
module --force purge
# only install gcc if not found      
spack find gcc@${GCCVER} && spack find gcc@${GCCVER} | grep "gcc@${GCCVER}" || spack install gcc@${GCCVER}
spack load --first gcc@${GCCVER}
spack compiler find
spack env activate -d ./env-${ENV} || exit 1
spack concretize -f || exit 1
spack install || exit 1
spack load cmake cuda hdf5 mpi || exit 1

# Git
cd ${PROJROOT}
git checkout ${COMMIT} || exit 1

# CMake
rm -rf ./build-debug-${ENV}-${COMMIT}/CMakeCache.txt ./build-${ENV}-${COMMIT}/CMakeFiles/
mkdir -p ./build-debug-${ENV}-${COMMIT}
cd build-debug-${ENV}-${COMMIT}
cmake .. -DCMAKE_BUILD_TYPE=Debug -DKokkos_ENABLE_DEBUG_BOUNDS_CHECK=ON -DCUDA=on && make -j
