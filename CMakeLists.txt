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

cmake_minimum_required(VERSION 3.3.0)

project(libACE)
include(ExternalProject)

set(ACE_VERSION "6.4.7" CACHE  STRING "ACE version")

if (UNIX)
  set (platform "linux")
elseif(APPLE)
  set (platform "macosx")
endif()

configure_file(${CMAKE_SOURCE_DIR}/build_ace.sh 
                 ${CMAKE_BINARY_DIR}
                  COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/configure_ace.sh 
                 ${CMAKE_BINARY_DIR}
                  COPYONLY)
ExternalProject_Add(
  ACE
  #URL http://download.dre.vanderbilt.edu/previous_versions/ACE-${ACE_VERSION}.zip
  URL https://www.ccppetmr.ac.uk/sites/www.ccppetmr.ac.uk/files/downloads/ACE-6.4.7.zip
  CONFIGURE_COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/configure_ace.sh -p ${platform} -s ${CMAKE_CURRENT_BINARY_DIR}/source -j 1
  BUILD_COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/build_ace.sh -p ${platform} -s ${CMAKE_CURRENT_BINARY_DIR}/source -j 1
  #BUILD_COMMAND ""

  INSTALL_COMMAND ""
  INSTALL_COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/build_ace.sh -p ${platform} -s ${CMAKE_CURRENT_BINARY_DIR}/source -j 1 -b 0
  #CONFIGURE_COMMAND cmake -E environment
  BINARY_DIR ${CMAKE_BINARY_DIR}/build/
  #SOURCE_DIR ${CMAKE_SOURCE_DIR}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  STAMP_DIR ${CMAKE_BINARY_DIR}/stamp
  TMP_DIR ${CMAKE_BINARY_DIR}/tmp
  DOWNLOAD_DIR ${CMAKE_BINARY_DIR}/download
  SOURCE_DIR ${CMAKE_BINARY_DIR}/source
  #BUILD_COMMAND make -j1 VERBOSE=1
  STEP_TARGETS install_
  
)

#if (UNIX)
#  configure_file(${CMAKE_SOURCE_DIR}/build_ace.sh 
#                 ${CMAKE_BINARY_DIR}
#                 COPYONLY)
#  execute_process(COMMAND 
#    bash build_ace.sh -p linux -v ${ACE_VERSION} -j2
#    RESULT_VARIABLE HAS_BUILT
#    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
#  )
#elseif (APPLE)
#  configure_file(${CMAKE_SOURCE_DIR}/build_ace.sh 
#                 ${CMAKE_BINARY_DIR}
#                 COPYONLY)
#  execute_process(COMMAND 
#    bash build_ace.sh -p macosx -v ${ACE_VERSION} -j2
#    RESULT_VARIABLE HAS_BUILT
#    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
#  )
#else()
#  message(FATAL_ERROR "Builds only on Linux and MacOSX so far")
#endif()


#if (${HAS_BUILT})
#  message(FATAL_ERROR "Configure or build error occurred.")
#endif()

#add_custom_target(libACE ALL
#    command make -j2
#    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/src/ace
#    VERBATIM
#)
if (UNIX)
	install(FILES
		${CMAKE_BINARY_DIR}/src/install/lib/libACE.so
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_ETCL.so
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_ETCL_Parser.so
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_Compression.so
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_RLECompression.so
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_Monitor_Control.so
		${CMAKE_BINARY_DIR}/src/install/lib/libACE.so.${ACE_VERSION}
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_ETCL.so.${ACE_VERSION}
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_ETCL_Parser.so.${ACE_VERSION}
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_Compression.so.${ACE_VERSION}
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_RLECompression.so.${ACE_VERSION}
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_Monitor_Control.so.${ACE_VERSION}
		DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
	)
elseif (APPLE)
	install(FILES
		${CMAKE_BINARY_DIR}/src/install/lib/libACE.dylib
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_ETCL.dylib
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_ETCL_Parser.dylib
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_Compression.dylib
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_RLECompression.dylib
		${CMAKE_BINARY_DIR}/src/install/lib/libACE_Monitor_Control.dylib
		#${CMAKE_BINARY_DIR}/src/install/lib/libACE.so.${ACE_VERSION}
		#${CMAKE_BINARY_DIR}/src/install/lib/libACE_ETCL.so.${ACE_VERSION}
		#${CMAKE_BINARY_DIR}/src/install/lib/libACE_ETCL_Parser.so.${ACE_VERSION}
		#${CMAKE_BINARY_DIR}/src/install/lib/libACE_Compression.so.${ACE_VERSION}
		#${CMAKE_BINARY_DIR}/src/install/lib/libACE_RLECompression.so.${ACE_VERSION}
		#${CMAKE_BINARY_DIR}/src/install/lib/libACE_Monitor_Control.so.${ACE_VERSION}
		DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
	)
endif()
install(DIRECTORY
    ${CMAKE_BINARY_DIR}/src/ACE_wrappers/ace
    DESTINATION ${CMAKE_INSTALL_PREFIX}/include/
    PATTERN "*.h"
    PATTERN "*.inl"
)

