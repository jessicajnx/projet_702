#!/usr/bin/env bash
#SBATCH --account="r260084"
#SBATCH --time=00:30:00
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=18
#SBATCH --constraint=armgpu
#SBATCH --job-name="dftb_run"
#SBATCH --comment "Projet CHPS0702"
#SBATCH --error=run_%J.err
#SBATCH --output=run_%J.out

romeo_load_armgpu_env

spack load /t66udn5 # gcc
spack load openblas@0.3.28
spack load /i6r3tsl # openmpi

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PLACES=cores
export OMP_PROC_BIND=close

export DFTBPLUS_PARAM_DIR="$HOME/opt/slakos"
BINARY_PATH="$HOME/opt/dftbplus/bin/dftb+"

export UCX_NET_DEVICES=mlx5_0:1
MPIFLAGS="-x UCX_NET_DEVICES=mlx5_0:1 -x OMP_NUM_THREADS -x OMP_PLACES -x OMP_PROC_BIND"

echo "==> Début du calcul DFTB+ ($(date))"
echo "Nb processus MPI : $SLURM_NTASKS"
echo "Nb threads OpenMP par tâche : $OMP_NUM_THREADS"

mpirun -np $SLURM_NTASKS $MPIFLAGS $BINARY_PATH

echo "==> Calcul terminé ($(date))"