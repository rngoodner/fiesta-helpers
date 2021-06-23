# fiesta-helpers

Convenience scripts for building and running FIESTA. These are the scripts I have been using to help build/run FIESTA on Xena to test run-times after source modifications and with different implementation of MPI.

# Build script

The build script will set up an environment with Spack and then build fiesta into a directory named `build-<env>-<commit-hash>`.

## Usage

`./build.sh <path-to-fiesta-clone> <commit-hash> <env-type>`

Currently supported env-types are: `openmpi`, `mpich`, and `mvapich2`.

# Run script

The run script will load the spack environment and the run a specified test a specified number of times.

## Usage

`./run.sh <path-to-fiesta-binary> <path-to-test-dir> <env-type> <number-of-runs>`

### Slurm script example

```
#!/bin/bash
#SBATCH --job-name=openmpi-host
#SBATCH --output=./log-%x.%J.out
#SBATCH --error=./log-%x.%J.err
#SBATCH --nodes=4
#SBATCH --time=10:00:00
#SBATCH --partition=singleGPU
#SBATCH --gres=gpu:1

cd ~/programming/fiesta-helpers/
./run.sh ~/programming/cup-ecs-fiesta/build-openmpi-master/fiesta ./idexp3dterrain-host/ openmpi 25
```

# Get run times

`parse.awk` can be used to extract run-times from a slurm output consisting of many runs.
The output is formatted as a python list so results can easily be plotted.

## Example

```
rgoodner@xena host-mod]$ ./parse.awk fiesta-host-mod.32325.out
Found [1]: Total Time:                              6.71e+02
Found [2]: Total Time:                              6.77e+02
Found [3]: Total Time:                              6.73e+02
Found [4]: Total Time:                              6.74e+02
Found [5]: Total Time:                              6.80e+02
Found [6]: Total Time:                              6.72e+02
Found [7]: Total Time:                              6.74e+02
Found [8]: Total Time:                              6.72e+02
Found [9]: Total Time:                              6.72e+02
Found [10]: Total Time:                              6.79e+02
Found [11]: Total Time:                              6.78e+02
Found [12]: Total Time:                              6.77e+02
Found [13]: Total Time:                              6.76e+02
Found [14]: Total Time:                              6.74e+02
Found [15]: Total Time:                              6.77e+02
Found [16]: Total Time:                              6.79e+02
Found [17]: Total Time:                              6.78e+02
Found [18]: Total Time:                              6.73e+02
Found [19]: Total Time:                              6.73e+02
Found [20]: Total Time:                              6.75e+02
Found [21]: Total Time:                              6.81e+02
Found [22]: Total Time:                              6.76e+02
Found [23]: Total Time:                              6.75e+02
Found [24]: Total Time:                              6.76e+02
Found [25]: Total Time:                              6.74e+02
[6.71e+02, 6.77e+02, 6.73e+02, 6.74e+02, 6.80e+02, 6.72e+02, 6.74e+02, 6.72e+02, 6.72e+02, 6.79e+02, 6.78e+02, 6.77e+02, 6.76e+02, 6.74e+02, 6.77e+02, 6.79e+02, 6.78e+02, 6.73e+02, 6.73e+02, 6.75e+02, 6.81e+02, 6.76e+02, 6.75e+02, 6.76e+02, 6.74e+02]
```
