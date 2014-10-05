#broija 2014/10/01
#CMakeLists.txt for tesseract-ocr 3.02.02

cmake_minimum_required(VERSION 2.8)

set(PROJECT_NAME tesseract)
project(${PROJECT_NAME})

#Training apps
#add_subdirectory(training)

#_-_-_-_-_-_SOME DIRECTORIES_-_-_-_-_-_
set(OCR_DIR D:/prog/ocr)
set(MINGW_DIR D:/Programs/Qt/Qt5.1.0/Tools/mingw48_32/i686-w64-mingw32)
set(MINGW_LIB_DIR ${MINGW_DIR}/lib)
set(LEPTONICA_DIR ${OCR_DIR}/leptonica-1.69)

set(ADDITIONAL_DIR additional)
set(VIEWER_DIR viewer)
#-_-_-_-_-_-

#_-_-_-_-_-_VERSION#_-_-_-_-_-_
set(LIB_VERSION_MAJOR 3)
set(LIB_VERSION_MINOR 02)
set(LIB_VERSION_PATCH 02)

set(VERSION_STRING ${LIB_VERSION_MAJOR}.${LIB_VERSION_MINOR}.${LIB_VERSION_PATCH})

#Writing version to version.h
file(WRITE ${ADDITIONAL_DIR}/version.h "#define VERSION \"${VERSION_STRING}\"" )
#-_-_-_-_-_-

#_-_-_-_-_-_TARGETS_-_-_-_-_-_
set(TARGET_LIB_TESSERACT ${PROJECT_NAME}${VERSION_STRING})

set(TARGET_APP_SVPAINT svpaint)
set(TARGET_APP_TESSERACT tesseract)
#-_-_-_-_-_-

#_-_-_-_-_-_DIRECTORIES AND FILES_-_-_-_-_-_
set(CMAKE_BINARY_DIR ../${PROJECT_NAME}_output)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

#----Headers----
file(GLOB_RECURSE HEADER_FILES "*.h")

set(LIB_INCLUDE_DIRS "")

foreach (_header_file ${HEADER_FILES})
    get_filename_component(_dir ${_header_file} PATH)
    list (APPEND LIB_INCLUDE_DIRS ${_dir})
endforeach()

list(REMOVE_DUPLICATES LIB_INCLUDE_DIRS)

include_directories(${LIB_INCLUDE_DIRS} ${LEPTONICA_DIR}/src)

#----Sources----
set(LIB_SOURCE_DIRS "")
set(LIB_SOURCE_FILES "")

list(APPEND LIB_SOURCE_DIRS ${ADDITIONAL_DIR}/
                            api/
                            ccmain/
                            ccstruct/
                            ccutil/
                            classify/
                            cube/
                            cutil/
                            dict/
                            image/
                            neural_networks/runtime/
                            textord/
                            ${VIEWER_DIR}/
                            vs2008/port/
                            wordrec/
)

foreach (_source_dir ${LIB_SOURCE_DIRS})
    set(TEMP_SOURCE_FILES "")

    file(GLOB TEMP_SOURCE_FILES "${_source_dir}*.cpp")

    list(APPEND LIB_SOURCE_FILES ${TEMP_SOURCE_FILES})
endforeach()

#Defining and removing "main" files from lib sources
set(MAIN_FILE_SVPAINT ${VIEWER_DIR}/${TARGET_APP_SVPAINT}.cpp)
get_filename_component(_file_to_remove ${MAIN_FILE_SVPAINT} ABSOLUTE)
list(REMOVE_ITEM LIB_SOURCE_FILES ${_file_to_remove})

set(MAIN_FILE_TESSERACT api/${TARGET_APP_TESSERACT}main.cpp)
get_filename_component(_file_to_remove ${MAIN_FILE_TESSERACT} ABSOLUTE)
list(REMOVE_ITEM LIB_SOURCE_FILES ${_file_to_remove})
#-_-_-_-_-_-

#_-_-_-_-_-_BUILD OUTPUTS_-_-_-_-_-_
#Library
add_library(${TARGET_LIB_TESSERACT} SHARED ${LIB_SOURCE_FILES})

#svpaint
add_executable(${TARGET_APP_SVPAINT} ${MAIN_FILE_SVPAINT})
add_dependencies(${TARGET_APP_SVPAINT} ${TARGET_LIB_TESSERACT})

#tesseract app
add_executable(${TARGET_APP_TESSERACT} ${MAIN_FILE_TESSERACT})
add_dependencies(${TARGET_APP_TESSERACT} ${TARGET_LIB_TESSERACT})
#-_-_-_-_-_-

set(WINDLL_NAME \"lib${TARGET_LIB_TESSERACT}.dll\")
add_definitions(-D_tagBLOB_DEFINED
                -D__BLOB_T_DEFINED
                -DUSE_STD_NAMESPACE
                -DWINDLLNAME=${WINDLL_NAME})

#_-_-_-_-_-_LINKING_-_-_-_-_-_
set(CMAKE_FIND_LIBRARY_SUFFIXES .a ${CMAKE_FIND_LIBRARY_SUFFIXES})

find_library(LEPTONICA_LIB NAMES lept
                                 lept-3
                                 liblept
                                 liblept-3
                                 PATHS ${LEPTONICA_DIR}/bin)

find_library(WS2_32_LIB NAMES libws2_32.a
                              PATHS ${MINGW_LIB_DIR}
                              NO_DEFAULT_PATH
                              NO_SYSTEM_ENVIRONMENT_PATH)

target_link_libraries(${TARGET_LIB_TESSERACT} ${LEPTONICA_LIB} ${WS2_32_LIB})
target_link_libraries(${TARGET_APP_SVPAINT} ${TARGET_LIB_TESSERACT})
target_link_libraries(${TARGET_APP_TESSERACT} ${TARGET_LIB_TESSERACT})
#-_-_-_-_-_-