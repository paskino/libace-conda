#========================================================================
# Author: Edoardo Pasca
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

cmake_minimum_required(VERSION 3.9.0)

project(libACE)
include(ExternalProject)

set(ACE_VERSION "6.5.9" CACHE  STRING "ACE version")

if (APPLE)
  set (platform "macosx")
elseif(UNIX)
  set (platform "linux")
endif()

configure_file(${CMAKE_SOURCE_DIR}/build_ace.sh 
                 ${CMAKE_BINARY_DIR}
                  COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/configure_ace.sh 
                 ${CMAKE_BINARY_DIR}
                  COPYONLY)
ExternalProject_Add(
  ACE
  URL http://download.dre.vanderbilt.edu/previous_versions/ACE-${ACE_VERSION}.zip
  #URL https://www.ccppetmr.ac.uk/sites/www.ccppetmr.ac.uk/files/downloads/ACE-6.4.7.zip
  CONFIGURE_COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/configure_ace.sh -p ${platform} -s ${CMAKE_CURRENT_BINARY_DIR}/source -j 1

  BUILD_COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/build_ace.sh -p ${platform} -s ${CMAKE_CURRENT_BINARY_DIR}/source -j 2 -l ${LIBRARY_DIR} -i ${INCLUDE_DIR}


  INSTALL_COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/build_ace.sh -p ${platform} -s ${CMAKE_CURRENT_BINARY_DIR}/source -j 2 -b 0 -l ${LIBRARY_DIR} -i ${INCLUDE_DIR}
  LOG_INSTALL 1
  BINARY_DIR ${CMAKE_BINARY_DIR}/build/
  INSTALL_DIR ${LIBRARY_DIR}
  STAMP_DIR ${CMAKE_BINARY_DIR}/stamp
  TMP_DIR ${CMAKE_BINARY_DIR}/tmp
  DOWNLOAD_DIR ${CMAKE_BINARY_DIR}/download
  SOURCE_DIR ${CMAKE_BINARY_DIR}/source
)

