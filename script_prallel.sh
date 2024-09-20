#!/bin/sh
#########################################
# REQUISITOS PARA EJECUTAR ESTE SCRIPT
#########################################
# 1) Tener permisos de sudo y permisos de ejecución en este script.
#     * Para ejecutar este script, puedes escribir en la terminal:
#       + $ chmod +x script_parallel.sh
#       + $ ./script_parallel.sh
#
# 2) Descargar los códigos fuente: (Recomendado por los desarrolladores de Xyce)
#     * https://xyce.sandia.gov/downloads/source-code/ (Si es necesario, regístrate con un email)
#     * https://github.com/trilinos/Trilinos/releases/tag/trilinos-release-12-12-1/ (Código fuente (tar.gz))
#     * O puedes usar un repositorio que contiene estos dos archivos en uno de los siguientes enlaces:
#       + HTTPS: https://github.com/IvoGC/downloads_needed_XYCE.git
#       + SSH: git@github.com:IvoGC/downloads_needed_XYCE.git
#
# 3) Esta instalación creará un directorio en el $PWD llamado Xyce_PB que contendrá:
#     * Downloads: contiene los archivos .tar
#     * XyceLibs/Parallel: contiene la compilación de Trilinos para la compilación en paralelo
#     * Trilinos12.12: contiene la versión 12.12 de Trilinos
#     * Xyce_configure: contiene la configuración para realizar la compilación en paralelo
#     * Xyce_parallel_build: ruta hacia la compilación en paralelo
#     * XyceInstall/Parallel: ruta de instalación de Xyce en paralelo
#
# Esto es en caso de que tengas que redefinir tu directorio home.
#########################################
# PREPARAR EL DIRECTORIO
#########################################
mkdir $PWD/Xyce_PB

INSTALL_DIR=$PWD/Xyce_PB

cd $INSTALL_DIR
mkdir $INSTALL_DIR/XyceLibs
mkdir $INSTALL_DIR/XyceLibs/Parallel

#########################################
# DESCARGAR ARCHIVOS COMPRIMIDOS
#########################################

sudo apt-get install git-lfs
git clone https://github.com/IvoGC/downloads_needed_XYCE.git Downloads
cd $INSTALL_DIR/Downloads 
git lfs install
cd $INSTALL_DIR

#########################################
# INSTALAR BIBLIOTECAS REQUERIDAS
#########################################

sudo apt-get install gcc g++ gfortran make cmake bison flex libfl-dev libfftw3-dev libsuitesparse-dev libblas-dev liblapack-dev libtool 
# Si se extraen desde repositorios de GitHub, debes ejecutar estas líneas:
# sudo apt-get install autoconf automake git
# Si estás compilando la versión paralela de Xyce
sudo apt-get install libopenmpi-dev openmpi-bin

#########################################
# INSTALAR TRILINOS-12-12-1
#########################################

#  Segun el Fabricangte no se garantiza que Xyce se compile correctamente con otras versiones de Trilinos.

#  SE PUEDE DESCARGAR CÓDIGO FUENTE DESDE: https://github.com/trilinos/Trilinos/releases/tag/trilinos-release-12-12-1/

mkdir $INSTALL_DIR/Trilinos12.12
cd $INSTALL_DIR/Trilinos12.12
# Cambia la ruta del archivo trilinos.tar para descomprimir este archivo
tar xzf $INSTALL_DIR/Downloads/Trilinos-trilinos-release-12-12-1.tar.gz


#########################################
# COMPILAR TRILINOS PARA XYCE EN PARALELO
#########################################

# Invocar CMake especificando todos los parámetros necesarios

SRCDIR=$INSTALL_DIR/Trilinos12.12/Trilinos-trilinos-release-12-12-1
ARCHDIR=$INSTALL_DIR/XyceLibs/Parallel
FLAGS="-O3 -fPIC"
cmake \
-G "Unix Makefiles" \
-DCMAKE_C_COMPILER=mpicc \
-DCMAKE_CXX_COMPILER=mpic++ \
-DCMAKE_Fortran_COMPILER=mpif77 \
-DCMAKE_CXX_FLAGS="$FLAGS" \
-DCMAKE_C_FLAGS="$FLAGS" \
-DCMAKE_Fortran_FLAGS="$FLAGS" \
-DCMAKE_INSTALL_PREFIX=$ARCHDIR \
-DCMAKE_MAKE_PROGRAM="make" \
-DTrilinos_ENABLE_NOX=ON \
  -DNOX_ENABLE_LOCA=ON \
-DTrilinos_ENABLE_EpetraExt=ON \
  -DEpetraExt_BUILD_BTF=ON \
  -DEpetraExt_BUILD_EXPERIMENTAL=ON \
  -DEpetraExt_BUILD_GRAPH_REORDERINGS=ON \
-DTrilinos_ENABLE_TrilinosCouplings=ON \
-DTrilinos_ENABLE_Ifpack=ON \
-DTrilinos_ENABLE_Isorropia=ON \
-DTrilinos_ENABLE_AztecOO=ON \
-DTrilinos_ENABLE_Belos=ON \
-DTrilinos_ENABLE_Teuchos=ON \
-DTrilinos_ENABLE_COMPLEX_DOUBLE=ON \
-DTrilinos_ENABLE_Amesos=ON \
 -DAmesos_ENABLE_KLU=ON \
-DTrilinos_ENABLE_Amesos2=ON \
 -DAmesos2_ENABLE_KLU2=ON \
 -DAmesos2_ENABLE_Basker=ON \
-DTrilinos_ENABLE_Sacado=ON \
-DTrilinos_ENABLE_Stokhos=ON \
-DTrilinos_ENABLE_Kokkos=ON \
-DTrilinos_ENABLE_Zoltan=ON \
-DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=OFF \
-DTrilinos_ENABLE_CXX11=ON \
-DTPL_ENABLE_AMD=ON \
-DAMD_LIBRARY_DIRS="/usr/lib" \
-DTPL_AMD_INCLUDE_DIRS="/usr/include/suitesparse" \
-DTPL_ENABLE_BLAS=ON \
-DTPL_ENABLE_LAPACK=ON \
-DTPL_ENABLE_MPI=ON \
$SRCDIR

# INSTALAR TRILINOS PARA XYCE EN PARALELO
make
make install
cd $INSTALL_DIR

#########################################
# DESCARGAR Y DESCOMPRIMIR CÓDIGO FUENTE DE XYCE
#########################################

# La descarga desde el sitio web es el MÉTODO DE DESCARGA RECOMENDADO
# https://xyce.sandia.gov/downloads/source-code/ (VERIFICAR LA VERSIÓN En caso de no haberlo descargado desde el repositorio)  

mkdir $INSTALL_DIR/Xyce_configure
cd $INSTALL_DIR/Xyce_configure
tar xzf $INSTALL_DIR/Downloads/Xyce-7.8.tar.gz
cd $INSTALL_DIR

# NOTA: usando otra versión, cambia Xyce-7.8 a Xyce-x.x para la nueva versión.

#########################################
# COMPILAR XYCE PARALELO
#########################################

mkdir $INSTALL_DIR/Xyce_parallel_build
cd $INSTALL_DIR/Xyce_parallel_build

# Invocar CMake especificando todos los parámetros necesarios
$INSTALL_DIR/Xyce_configure/Xyce-7.8/configure \
CXXFLAGS="-O3" \
ARCHDIR="$INSTALL_DIR/XyceLibs/Parallel" \
CPPFLAGS="-I/usr/include/suitesparse" \
--enable-mpi \
CXX=mpicxx \
CC=mpicc \
F77=mpif77 \
--enable-stokhos \
--enable-amesos2 \
--prefix=$INSTALL_DIR/XyceInstall/Parallel

# INSTALAR XYCE EN PARALELO
make
sudo make install
cd $INSTALL_DIR/..

echo "El script se ha ejecutado con éxito."










