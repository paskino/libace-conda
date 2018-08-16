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
threads=1
is_build="1"
while getopts p:v:j:s:i:b:h option
 do
 case "${option}"
  in
  p) target=$OPTARG;;
  v) version=$OPTARG;;
  j) threads=$OPTARG;;
  s) src=$OPTARG;;
  i) INSTALL_DIR=${OPTARG};;
  b) is_build=${OPTARG};;
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

#mkdir src 
#cd src 
WORKING_DIR=${src}
echo ${WORKING_DIR}
#export ACE_ROOT=${WORKING_DIR}/ACE_wrappers
export ACE_ROOT=${WORKING_DIR}/

cd ${ACE_ROOT}/ace 
if [ ${is_build} = "1" ]; then
  make -j${threads}
else
  # copy all the binaries to the install directory
echo "**************************************************************"
echo "Copying to install directory"
echo "**************************************************************"
cd ${WORKING_DIR}
#INSTALL_DIR=${WORKING_DIR}/install/lib
mkdir -p $INSTALL_DIR
if [ $target = "linux" ] ; then
  
  cp -v ${ACE_ROOT}/ace/libACE.so.${version} ${INSTALL_DIR}
  if [ -h ${INSTALL_DIR}/libACE.so ] ; then
    rm  ${INSTALL_DIR}/libACE.so
  fi
  ln -s ${INSTALL_DIR}/libACE.so.${version} ${INSTALL_DIR}/libACE.so

  cp -v ${ACE_ROOT}/ace/ETCL/libACE_ETCL.so.${version} ${INSTALL_DIR}
  cp -v ${ACE_ROOT}/ace/ETCL/libACE_ETCL_Parser.so.${version} ${INSTALL_DIR}
  if [ -h ${INSTALL_DIR}/libACE_ETCL.so ] ; then
    rm  ${INSTALL_DIR}/libACE_ETCL.so
  fi
  ln -s ${INSTALL_DIR}/libACE_ETCL.so.${version} ${INSTALL_DIR}/libACE_ETCL.so
  if [ -h ${INSTALL_DIR}/libACE_ETCL_Parser.so ] ; then
    rm  ${INSTALL_DIR}/libACE_ETCL_Parser.so
  fi
  ln -s ${INSTALL_DIR}/libACE_ETCL_Parser.so.${version} ${INSTALL_DIR}/libACE_ETCL_Parser.so

  cp -v ${ACE_ROOT}/ace/Compression/libACE_Compression.so.${version} ${INSTALL_DIR}
  if [ -h ${INSTALL_DIR}/libACE_Compression.so ] ; then
    rm  ${INSTALL_DIR}/libACE_Compression.so
  fi
  ln -s ${INSTALL_DIR}/libACE_Compression.so.${version} ${INSTALL_DIR}/libACE_Compression.so
  cp -v ${ACE_ROOT}/ace/Compression/rle/libACE_RLECompression.so.${version} ${INSTALL_DIR}
  if [ -h ${INSTALL_DIR}/libACE_RLECompression.so ] ; then
    rm  ${INSTALL_DIR}/libACE_RLECompression.so
  fi
  ln -s ${INSTALL_DIR}/libACE_RLECompression.so.${version} ${INSTALL_DIR}/libACE_RLECompression.so

  cp -v ${ACE_ROOT}/ace/Monitor_Control/libACE_Monitor_Control.so.${version} ${INSTALL_DIR}
  if [ -h ${INSTALL_DIR}/libACE_Monitor_Control.so ] ; then
    rm  ${INSTALL_DIR}/libACE_Monitor_Control.so
  fi
  ln -s ${INSTALL_DIR}/libACE_Monitor_Control.so.${version} ${INSTALL_DIR}/libACE_Monitor_Control.so

elif [ $target = "macosx" ] ; then
 
  cp -v ${ACE_ROOT}/ace/libACE.dylib ${INSTALL_DIR}
  cp -v ${ACE_ROOT}/ace/ETCL/libACE_ETCL.dylib ${INSTALL_DIR}
  cp -v ${ACE_ROOT}/ace/ETCL/libACE_ETCL_Parser.dylib ${INSTALL_DIR}
  cp -v ${ACE_ROOT}/ace/Compression/libACE_Compression.dylib ${INSTALL_DIR}
  cp -v ${ACE_ROOT}/ace/Compression/rle/libACE_RLECompression.dylib ${INSTALL_DIR}
  cp -v ${ACE_ROOT}/ace/Monitor_Control/libACE_Monitor_Control.dylib ${INSTALL_DIR}
fi
rsync -rv --include '*/' --include '*.h' --exclude '*' --prune-empty-dirs ${ACE_ROOT}/ace ${INSTALL_DIR}/include
rsync -rv --include '*/' --include '*.inl' --exclude '*' --prune-empty-dirs ${ACE_ROOT}/ace ${INSTALL_DIR}/include
fi
