#!/bin/bash

if test "$#" -ne 6; then
    echo "Usage: ./run.sh <path-to-fiesta-binary> <path-to-test-dir> <env-file-to-source> <"scheduler command"> <gpus-per-node> <number-of-runs>"
    exit 1
fi

# Collect arguments and set variables
export FIESTABIN=$(realpath $1)
export TESTDIR=$2
export ENV=$3
export CMD=$4
export GPUPN=$5
export RUNS=$6

# Environment
. ${ENV} || exit 1

# Run
export TESTDIRCOPY=./$(basename ${TESTDIR})_$(basename ${ENV})_$(date --iso-8601=seconds)
cp -r ${TESTDIR} ${TESTDIRCOPY}
cd ${TESTDIRCOPY}
for i in $(seq 1 $RUNS); do
	echo "------ RUN ${i} STARTING ------"
	${CMD} ${FIESTABIN} ./fiesta.lua --kokkos-num-devices=${GPUPN}
	echo "------ RUN ${i} COMPLETE ------"
done
