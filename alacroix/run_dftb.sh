#!/usr/bin/env bash
#SBATCH --account="r260084"
#SBATCH --time=1:00:00
#SBATCH --mem=64G
#SBATCH --constraint=armgpu
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=18
#SBATCH --job-name="dftb_run"
#SBATCH --comment "Projet CHPS0702"
#SBATCH --error=run_dftbplus.%J.err
#SBATCH --output=run_dftbplus.%J.out

romeo_load_armgpu_env

spack load /t66udn5 # gcc
spack load /tghyko6 # openblas
spack load /i6r3tsl # openmpi
spack load netlib-scalapack@2.2.2

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export DFTBPLUS_PARAM_DIR="$HOME/opt/slakos/dftb_input"

BINARY_PATH="$HOME/opt/dftbplus/bin/dftb+"

cd $DFTBPLUS_PARAM_DIR
mpirun -np $SLURM_NTASKS $BINARY_PATH