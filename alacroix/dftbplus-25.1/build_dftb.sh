#!/bin/bash
set -e

# Dossiers d'installation et des dépendances
INSDIR=$HOME/opt/dftb+
ELSI_DIR=$HOME/opt/elsi

# Nettoyage du dossier de build précédent si besoin
rm -rf _build

echo "==> Configuration de DFTB+ avec CMake..."
cmake -DCMAKE_INSTALL_PREFIX=$INSDIR \
      -DWITH_MPI=ON \
      -DWITH_ELSI=OFF \
      -DCMAKE_PREFIX_PATH=$ELSI_DIR \
      -DSCALAPACK_LIBRARY="/usr/lib/x86_64-linux-gnu/libscalapack-openmpi.so" \
      -B _build .

echo "==> Compilation en cours..."
cd _build
make -j$(nproc)

echo "==> Installation..."
make install

echo "Terminé ! DFTB+ est installé dans $INSDIR"