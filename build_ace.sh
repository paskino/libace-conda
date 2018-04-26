#!/bin/bash
#========================================================================
# Author: Edoardo Pasca
# Author: Ben Thomas
# Copyright 2016 - 2018 University College London
# Copyright 2016 - 2018 Science Technology Facilities Council
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0.txt
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#=========================================================================

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
echo $version

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
  make -j2

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

  #include
  INCLUDE_DIR=${INSTALL_DIR}/include
  mkdir ${INCLUDE_DIR}/ace/os_include
  mkdir ${INCLUDE_DIR}/ace/Monitor_Control
  mkdir ${INCLUDE_DIR}/ace/SSL
  mkdir ${INCLUDE_DIR}/ace/ETCL
  h=`find ${ACE_ROOT}/ace/ -name '*.h' | sed 's/src\/ACE_wrappers\///'`

  for ff in h;
  do 
    cp -v ${ACE_ROOT}/$ff ${INCLUDE_DIR}/$ff
  done
  h=`find ${ACE_ROOT}/ace/ -name '*.inl' | sed 's/src\/ACE_wrappers\///'`

  for ff in h;
  do 
    cp -v ${ACE_ROOT}/$ff ${INCLUDE_DIR}/$ff
  done

fi
