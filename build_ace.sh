#!/bin/bash

version="6.4.7"
while getopts p:v:h option
 do
 case "${option}"
  in
  p) target=$OPTARG;;
  v) version=$OPTARG;;
  h)
   echo "Usage: $0 -p platform [-v ACE_Version]"
   echo "Use the platform option to build for a specific platform."
   echo "Currently only linux is available."
   echo "Use the -v to define a specific version, defaults to 6.4.7"
   exit 
   ;;
  *)
   echo "Wrong option passed. Use the -h option to get some help." >&2
   exit 1
  ;;
 esac
done

echo $target

if [ $target = "linux" ] ; then
  mkdir src 
  cd src 
  wget http://download.dre.vanderbilt.edu/previous_versions/ACE-${version}.zip
  unzip ACE-${version}.zip
  WORKING_DIR=`pwd`
  echo ${WORKING_DIR}
  export ACE_ROOT=${WORKING_DIR}/ACE_wrappers
  cd ${ACE_ROOT}/ace
  ln -s config-linux.h config.h
  cd ../include/makeinclude
  ln -s platform_linux.GNU platform_macros.GNU 
  cd ../../ace 
  #make -j2

  # copy all the binaries to the install directory
  cd ${WORKING_DIR}
  INSTALL_DIR=${WORKING_DIR}/install
  mkdir $INSTALL_DIR
  cp -v ${ACE_ROOT}/ace/libACE.so.${version} ${INSTALL_DIR}
  ln -s ${INSTALL_DIR}/libACE.so.${version} ${INSTALL_DIR}/libACE.so

  cp -v ${ACE_ROOT}/ace/ETCL/libACE_ETCL.so.${version} ${INSTALL_DIR}
  cp -v ${ACE_ROOT}/ace/ETCL/libACE_ETCL_Parser.so.${version} ${INSTALL_DIR}
  ln -s ${INSTALL_DIR}/libACE_ETCL.so.${version} ${INSTALL_DIR}/libACE_ETCL.so
  ln -s ${INSTALL_DIR}/libACE_ETCL_Parser.so.${version} ${INSTALL_DIR}/libACE_ETCL_Parser.so

  cp -v ${ACE_ROOT}/ace/Compression/libACE_Compression.so.${version} ${INSTALL_DIR}
  ln -s ${INSTALL_DIR}/libACE_Compression.so.${version} ${INSTALL_DIR}/libACE_Compression.so
  cp -v ${ACE_ROOT}/ace/Compression/rle/libACE_RLECompression.so.${version} ${INSTALL_DIR}
  ln -s ${INSTALL_DIR}/libACE_RLECompression.so.${version} ${INSTALL_DIR}/libACE_RLECompression.so

  cp -v ${ACE_ROOT}/ace/Monitor_Control/libACE_Monitor_Control.so.${version} ${INSTALL_DIR}
  ln -s ${INSTALL_DIR}/libACE_Monitor_Control.so.${version} ${INSTALL_DIR}/libACE_Monitor_Control.so

fi
