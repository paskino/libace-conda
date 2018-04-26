cmake_minimum_required(VERSION 3.3.0)

project(libACE)

set(ACE_VERSION "6.4.7" CACHE  STRING "ACE version")

if (UNIX)
  configure_file(${CMAKE_SOURCE_DIR}/build_ace.sh ${CMAKE_BINARY_DIR})
  execute_process(COMMAND 
    bash build_ace.sh -p linux -v ${ACE_VERSION}
    RESULT_VARIABLE HAS_BUILT
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
else()
  message(FATAL_ERROR "Builds only on Linux so far")
endif()

message("Has it built? ${HAS_BUILT}")

install(FILES
    ${CMAKE_BINARY_DIR}/src/install/libACE.so
    ${CMAKE_BINARY_DIR}/src/install/libACE_ETCL.so
    ${CMAKE_BINARY_DIR}/src/install/libACE_ETCL_Parser.so
    ${CMAKE_BINARY_DIR}/src/install/libACE_Compression.so
    ${CMAKE_BINARY_DIR}/src/install/libACE_RLECompression.so
    ${CMAKE_BINARY_DIR}/src/install/libACE_Monitor_Control.so
    ${CMAKE_BINARY_DIR}/src/install/libACE.so.${ACE_VERSION}
    ${CMAKE_BINARY_DIR}/src/install/libACE_ETCL.so.${ACE_VERSION}
    ${CMAKE_BINARY_DIR}/src/install/libACE_ETCL_Parser.so.${ACE_VERSION}
    ${CMAKE_BINARY_DIR}/src/install/libACE_Compression.so.${ACE_VERSION}
    ${CMAKE_BINARY_DIR}/src/install/libACE_RLECompression.so.${ACE_VERSION}
    ${CMAKE_BINARY_DIR}/src/install/libACE_Monitor_Control.so.${ACE_VERSION}
    DESTINATION ${CMAKE_INSTALL_PREFIX}
)
