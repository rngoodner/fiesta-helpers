#!/bin/bash
#SBATCH --job-name=openmpi-host-c7b0be8a2b7d
#SBATCH --output=./log-%x.%J.out
#SBATCH --error=./log-%x.%J.err
#SBATCH --nodes=4
#SBATCH --time=10:00:00
#SBATCH --partition=singleGPU
#SBATCH --gres=gpu:1

cd ~/programming/fiesta-helpers/
./run.sh ~/programming/cup-ecs-fiesta/build-openmpi-c7b0be8a2b7d/fiesta ./idexp3dterrain-host/ openmpi 25
