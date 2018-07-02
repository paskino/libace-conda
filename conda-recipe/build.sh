
mkdir ${SRC_DIR}/build
#cp -rv ${RECIPE_DIR}/.. ${SRC_DIR}/build
rsync -az --exclude=.git ${RECIPE_DIR}/../ ${SRC_DIR}/build
mkdir ${SRC_DIR}/build/build
cd ${SRC_DIR}/build/build
cmake -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLIBRARY_LIB="${CONDA_PREFIX}/lib" \
  -DLIBRARY_INC="${CONDA_PREFIX}"\
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DINSTALL_LIB_DIR="${PREFIX}/lib" \
  -DINSTALL_BIN_DIR="${PREFIX}/bin" \
  -DINSTALL_INCLUDE_DIR="${PREFIX}/include" \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}"\
  --debug-output ../

#cmake -G "Unix Makefiles" -DLIBRARY_LIB="%CONDA_PREFIX%\lib" -DLIBRARY_INC="%CONDA_PREFIX%" -DCMAKE_INSTALL_PREFIX="%PREFIX%\Library" -DINSTALL_LIB_DIR="%PREFIX%\Library\lib" -DINSTALL_BIN_DIR="%PREFIX%\Library\bin" -DINSTALL_INCLUDE_DIR="%PREFIX%\Library\include" "%SRC_DIR%\build" 

make -j1 VERBOSE=1
#make install
