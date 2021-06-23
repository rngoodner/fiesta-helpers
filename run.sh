#!/bin/bash

if test "$#" -ne 4; then
    echo "Usage: ./run.sh <path-to-fiesta-binary> <path-to-test-dir> <environment> <number-of-runs>"
    exit 1
fi

# Collect arguments and set variables
export FIESTABIN=$1
export TESTDIR=$2
export ENV=$3
export RUNS=$4
export GCCVER=9.4.0

# Spack
module purge
# only install gcc if not found      
spack find gcc@$GCCVER && spack find gcc@$GCCVER | grep "gcc@$GCCVER" || spack install gcc@$GCCVER
spack load --first gcc@$GCCVER
spack compiler find
spack env activate -d ./env-$ENV || exit 1
spack concretize -f || exit 1
spack install || exit 1
spack load cmake cuda hdf5 mpi || exit 1

# Run
cd $TESTDIR
# 4 nodes with 1 gpu each _should_ work most anywhere
for i in $(seq 1 $RUNS); do
	echo "------ START RUN $i ------"
	if [ $ENV = "openmpi" ]; then
		export OMPI_MCA_fs_ufs_lock_algorithm=1
		mpirun --mca btl '^openib' -n 4 $FIESTABIN ./fiesta.lua --kokkos-num-devices=1
	elif [ $ENV = "mvapich2" ]; then
		export MV2_USE_CUDA=1
		export MV2_USE_RDMA_CM=0
		export MV2_HOMOGENEOUS_CLUSTER=1
		mpirun -n 4 $FIESTABIN ./fiesta.lua --kokkos-num-devices=1
	else
		mpirun -n 4 $FIESTABIN ./fiesta.lua --kokkos-num-devices=1
	fi
	echo "------ RUN $i COMPLETE ------"
done
