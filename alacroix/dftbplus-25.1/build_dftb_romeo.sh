#!/usr/bin/env bash
#SBATCH --account="r260084"
#SBATCH --time=0:10:00
#SBATCH --mem=10G
#SBATCH --constraint=armgpu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name="dftb_build"
#SBATCH --comment "Projet CHPS0702"
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out

romeo_load_armgpu_env

spack load /t66udn5 # gcc
spack load openblas@0.3.28
spack load /i6r3tsl # openmpi
spack load /phhwuh3 #cmake

export CC=mpicc
export CXX=mpicxx
export FC=mpifort

INSDIR=$HOME/opt/dftbplus

ARM_FLAGS="-O3 -mcpu=neoverse-v2 -fopenmp"

rm -rf _build

cmake -DCMAKE_INSTALL_PREFIX=$INSDIR \
      -DWITH_MPI=ON \
      -DWITH_ELSI=OFF \
      -DCMAKE_C_COMPILER=mpicc \
      -DCMAKE_Fortran_COMPILER=mpifort \
      -DCMAKE_C_FLAGS="$ARM_FLAGS" \
      -DCMAKE_Fortran_FLAGS="$ARM_FLAGS" \
      -B _build .

cd _build
make -j$(nproc)

make install

echo -e "\n\nDFTB+ installé dans $INSDIR"