#!/bin/bash
#========================================================================
# Author: Edoardo Pasca
# Author: Ben Thomas
# Copyright 2016 - 2018 University College London
# Copyright 2016 - 2022 Science Technology Facilities Council
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

while getopts p:s:h option
 do
 case "${option}"
  in
  p) target=$OPTARG;;
  s) src=$OPTARG;;
  h)
   echo "Usage: $0 -p platform -s build_directory"
   echo "Use the platform option to build for a specific platform."
   echo "Use the build_directory option to specify the build directory."
   echo "Use -h for help"
   exit 
   ;;
  *)
   echo "Wrong option passed. Use the -h option to get some help." >&2
   exit 1
  ;;
 esac
done

echo $target

WORKING_DIR=${src}
echo ${WORKING_DIR}
export ACE_ROOT=${WORKING_DIR}/

if [ $target = "linux" ] ; then
  cd ${ACE_ROOT}/ace
  ln -s config-linux.h config.h
  cd ../include/makeinclude
  ln -s platform_linux.GNU platform_macros.GNU
  cd ../../ace  
elif [ $target = "macosx" ] ; then
  cd ${ACE_ROOT}/ace
  ln -s config-macosx.h config.h
  cd ../include/makeinclude
  ln -s platform_macosx.GNU platform_macros.GNU
  cd ../../ace  
fi

