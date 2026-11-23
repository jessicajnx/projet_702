#!/usr/bin/env bash
#SBATCH --account="r260084"
#SBATCH --time=1:00:00
#SBATCH --mem=64G
#SBATCH --constraint=armgpu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name="dftb_build"
#SBATCH --comment "Projet CHPS0702"
#SBATCH --error=build_dftbplus.%J.err
#SBATCH --output=build_dftbplus.%J.out

romeo_load_armgpu_env

spack load /gu5nyvm # gcc
spack load /phhwuh3 # cmake
spack load /i6r3tsl # openmpi
spack load /pkyzznx # netlib-scalapack
spack load /tghyko6 # openblas

export CC=gcc
export CXX=g++
export FC=gfortran

export CFLAGS="-mcpu=neoverse-v2"
export CXXFLAGS="-mcpu=neoverse-v2"
export FCFLAGS="-mcpu=neoverse-v2"

INSDIR=$HOME/opt/dftbplus

ARM_FLAGS="-O3 -mcpu=neoverse-v2 -fopenmp"

ARCHIVE="dftbplus-25.1.tar.xz"

if [ ! -d "dftbplus-25.1" ]; then
    if [ ! -f "${ARCHIVE}" ]; then
        wget https://github.com/dftbplus/dftbplus/releases/download/25.1/dftbplus-25.1.tar.xz
    fi
    tar -xf ${ARCHIVE}
fi

cd dftbplus-25.1

rm -rf _build
cmake -DCMAKE_INSTALL_PREFIX=$INSDIR \
    -DWITH_OMP=ON \
    -DWITH_MPI=ON \
    -DWITH_ELSI=OFF \
    -DLINALG_LIBRARIES="-lflexiblas -lscalapack" \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
    -B "_build" .

cd _build
make -j$(nproc)
make install

echo -e "\n\nDFTB+ installé dans $INSDIR"