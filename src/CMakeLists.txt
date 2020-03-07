# VS_DEBUGGER_ENVIRONMENT target property introduced in 3.13
cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

#######################################
## Set project-level cache variables ##
#######################################

# set new cmake policies
if(${CMAKE_VERSION} VERSION_GREATER_EQUAL 3.13)
	cmake_policy(VERSION 3.13)
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules")


# current versioning: major.minor.sprint.0
project(example-application
	VERSION     1.0.0.0
	DESCRIPTION "example-application"
)

message(STATUS "Configuring ${PROJECT_NAME} ${PROJECT_VERSION}")

#set project prefix for organizing 3rdParty/dependencies/etc
set(PROJECT_PREFIX "exapp")

if(NOT CMAKE_PREFIX_PATH)
    message(FATAL_ERROR "Please point CMAKE_PREFIX_PATH to your third-party dependencies directory")
endif()

# Make sure CMAKE_PREFIX_PATH uses Unix-style forward-slash path separators
file(TO_CMAKE_PATH ${CMAKE_PREFIX_PATH} CMAKE_PREFIX_PATH)

# Used by script files to set debug postfix in .bat files
set(CURRENT_BUILD_SUFFIX $<$<CONFIG:Debug>:d>)

###############
## FIND LIBS ##
###############

# Example cmake finds for common libraries

# Find Boost Library
#set(BOOST_ROOT ${CMAKE_PREFIX_PATH}/boost)
#set(Boost_USE_STATIC_LIBS ON)
#set(Boost_USE_MULTITHREADED ON)
#set(Boost_USE_STATIC_RUNTIME OFF)
#find_package(Boost REQUIRED
#	COMPONENTS 
#		atomic
#		chrono
#		date_time
#		filesystem
#		program_options
#		system
#		thread
#		timer
#	QUIET
#)
	
# ffmpeg - Required package:
#find_package( ffmpeg )
#if ( FFMPEG_FOUND )
#	message(STATUS "Found ffmpeg")
#	MESSAGE(STATUS "")    
#else()
#    message(FATAL_ERROR "Could not find ffmpeg!" )
#endif()

#find_package(jsoncpp REQUIRED CONFIG PATHS ${CMAKE_PREFIX_PATH}/jsoncpp/lib/cmake QUIET)

# Find Minizip/ZLIB
#if(WIN32)
#	find_package(ZLIB REQUIRED CONFIG NO_DEFAULT_PATH
#		PATHS ${CMAKE_PREFIX_PATH}/minizip
#		QUIET
#	)
#	find_package(minizip REQUIRED CONFIG PATHS ${CMAKE_PREFIX_PATH}/minizip QUIET)
#else()
#	find_package(minizip REQUIRED CONFIG)
#	find_package(ZLIB REQUIRED)
#endif()

#if(WIN32)
	# For OpenCV 3.2.0 and Visual Studio 2017, the correct CMake config modules
	# are in the lib folder, not the base install folder
#	find_package(OpenCV 3.4.6 REQUIRED CONFIG
#		COMPONENTS core
#                   dnn
#		           imgcodecs
#		           imgproc
#		           ml
#		           text
#		           videoio
#		NO_DEFAULT_PATH
#		PATHS ${CMAKE_PREFIX_PATH}/opencv/x64/vc15/lib
#		QUIET
#	)
#else()
#	set(OPENCV_DIR "/usr/local/opt/opencv3/")
#	find_package( OpenCV 3 REQUIRED HINTS "/usr/local/opt/opencv3/" QUIET)
#endif()

add_definitions( -DQT_NO_SIGNALS_SLOTS_KEYWORDS )
find_package(Qt5 REQUIRED CONFIG
	COMPONENTS 
		Core
		Gui
		Network
		Test
		Widgets
	PATHS ${CMAKE_PREFIX_PATH}/qt
	QUIET
)

###############################################
## Setup 3rd Party runtime paths for macOS   ##
###############################################
if(APPLE)
	file(
		COPY ${CMAKE_SOURCE_DIR}/../scripts/configure_dependency_rpath.bash
		DESTINATION ${CMAKE_BINARY_DIR}
	)
endif()

###############################################
## Setup 3rd Party runtime paths for VS path ##
###############################################
if(MSVC)
	# Set required third-party runtime paths to be appended to the user PATH
	# environment variable while running Visual Studio
	set(third_party_runtime_paths
		"${CMAKE_PREFIX_PATH}/qt/bin"
	)
	set(vs_debugger_environment "PATH=${third_party_runtime_paths};%PATH%")

	# Make 'application' the startup project
	set_property(
		DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
		PROPERTY  VS_STARTUP_PROJECT example-application
	)
	# Enable projects to be organized into a folder hierarchy in Visual Studio
	set_property(GLOBAL PROPERTY USE_FOLDERS YES)
endif()

# Enable testing first before adding any tests
enable_testing()

# Prevent overriding the parent project's compiler/linker settings on
# Windows
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

set(DISABLE_PUBLIC_HEADERS ON) #disable install headers since we're building an installer

add_subdirectory(dependencies)
add_subdirectory(example-application)

option(BUILD_DOCS "Build Doxygen HTML documentation" ON)
if(BUILD_DOCS)
	add_subdirectory(docs)
endif()

# Install project-level items
include(InstallRequiredSystemLibraries)
if(MSVC)
	# example install ffmpeg dlls
#	install(
#		FILES
#			${CMAKE_PREFIX_PATH}/ffmpeg/bin/avcodec-57.dll
#			${CMAKE_PREFIX_PATH}/ffmpeg/bin/avformat-57.dll
#			${CMAKE_PREFIX_PATH}/ffmpeg/bin/avutil-55.dll
#			${CMAKE_PREFIX_PATH}/ffmpeg/bin/swresample-2.dll
#			${CMAKE_PREFIX_PATH}/ffmpeg/bin/swscale-4.dll
#		DESTINATION bin
#	)

	# example install opencv dlls
#	install(
#		FILES
#            ${CMAKE_PREFIX_PATH}/opencv/x64/vc15/bin/opencv_core346$<$<CONFIG:Debug>:d>.dll
#            ${CMAKE_PREFIX_PATH}/opencv/x64/vc15/bin/opencv_dnn346$<$<CONFIG:Debug>:d>.dll
#            ${CMAKE_PREFIX_PATH}/opencv/x64/vc15/bin/opencv_ffmpeg346_64.dll
#            ${CMAKE_PREFIX_PATH}/opencv/x64/vc15/bin/opencv_highgui346$<$<CONFIG:Debug>:d>.dll
#            ${CMAKE_PREFIX_PATH}/opencv/x64/vc15/bin/opencv_imgcodecs346$<$<CONFIG:Debug>:d>.dll
#            ${CMAKE_PREFIX_PATH}/opencv/x64/vc15/bin/opencv_imgproc346$<$<CONFIG:Debug>:d>.dll
#            ${CMAKE_PREFIX_PATH}/opencv/x64/vc15/bin/opencv_ml346$<$<CONFIG:Debug>:d>.dll
#            ${CMAKE_PREFIX_PATH}/opencv/x64/vc15/bin/opencv_text346$<$<CONFIG:Debug>:d>.dll
#            ${CMAKE_PREFIX_PATH}/opencv/x64/vc15/bin/opencv_videoio346$<$<CONFIG:Debug>:d>.dll
#		DESTINATION bin
#	)

	# install Qt5 dlls
	install(
		FILES
			${CMAKE_PREFIX_PATH}/qt/bin/Qt5Core$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/bin/Qt5Gui$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/bin/Qt5Network$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/bin/Qt5Positioning$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/bin/Qt5Sensors$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/bin/Qt5Widgets$<$<CONFIG:Debug>:d>.dll
		DESTINATION bin
	)
	install(
		FILES
			${CMAKE_PREFIX_PATH}/qt/plugins/imageformats/qgif$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/plugins/imageformats/qicns$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/plugins/imageformats/qico$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/plugins/imageformats/qjpeg$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/plugins/imageformats/qsvg$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/plugins/imageformats/qtga$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/plugins/imageformats/qtiff$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/plugins/imageformats/qwbmp$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/plugins/imageformats/qwebp$<$<CONFIG:Debug>:d>.dll
		DESTINATION bin/imageformats
	)
	install(
		FILES
			${CMAKE_PREFIX_PATH}/qt/plugins/platforms/qdirect2d$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/plugins/platforms/qminimal$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/plugins/platforms/qoffscreen$<$<CONFIG:Debug>:d>.dll
			${CMAKE_PREFIX_PATH}/qt/plugins/platforms/qwindows$<$<CONFIG:Debug>:d>.dll
		DESTINATION bin/platforms
	)
	
	# install build_id	
	install(
		FILES
			${CMAKE_BINARY_DIR}/build_id.txt
		DESTINATION bin
	)

	# Set up the Qt configuration file used to locate Qt resources at runtime
	set(qt_prefix ${CMAKE_PREFIX_PATH})
	configure_file(
		${CMAKE_SOURCE_DIR}/cmake/qt.conf.in
		${CMAKE_BINARY_DIR}/qt.conf
		@ONLY
	)
	# Create them as needed for each configuration (Debug, Release, etc.)
	file(GENERATE
		OUTPUT ${CMAKE_BINARY_DIR}/$<CONFIG>/qt.conf
		INPUT  ${CMAKE_BINARY_DIR}/qt.conf
	)
	# Also create one in the installed location
	string(APPEND install_qt_conf_file
		"configure_file(                        "
		"   ${CMAKE_SOURCE_DIR}/cmake/qt.conf.in"
		"   ${CMAKE_INSTALL_PREFIX}/bin/qt.conf "
		"   @ONLY                               "
		")                                      "
	)
	install(CODE ${install_qt_conf_file})
	install(
		FILES ${CMAKE_INSTALL_PREFIX}/bin/qt.conf
		DESTINATION bin
	)

	file(GLOB scripts RELATIVE "${CMAKE_BINARY_DIR}/scripts" "${CMAKE_BINARY_DIR}/scripts/*.bat")
	foreach(script ${scripts})
		file(GENERATE
			OUTPUT "${CMAKE_BINARY_DIR}/$<CONFIG>/${script}"
			INPUT "${CMAKE_BINARY_DIR}/scripts/${script}"
		)
	endforeach()
endif()

if(NOT ${CPACK_GENERATOR} STREQUAL "NSIS")
    # Put contents in a top-level folder named
    # ${PROJECT_NAME}-${PROJECT_VERSION} (doesn't work with NSIS)
    set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY YES)
endif()

set(CPACK_MONOLITHIC_INSTALL YES)

# Allow the archive generators (ZIP, TGZ, etc.) to generate component-based
# packages
set(CPACK_ARCHIVE_COMPONENT_INSTALL YES)

# Combine all components into one; don't give the user the option to
# select/deselect components
set(CPACK_COMPONENTS_ALL_IN_ONE_PACKAGE)


set(PACKAGE_NAME ${PROJECT_NAME})
set(CPACK_PACKAGE_NAME ${PACKAGE_NAME})
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PROJECT_DESCRIPTION})
set(CPACK_PACKAGE_VENDOR "Organization Name")
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_CURRENT_LIST_DIR}/LICENSE)
if(MSVC)
    set(tool_file_extension ".exe")
endif()
set(CPACK_NSIS_DELETE_ICONS_EXTRA
	"Delete '$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\example-application.lnk'"
)

option(ADMIN_REQUIRED_INSTALLER
    "Create an installer that requires administrative privileges" OFF
)
if(ADMIN_REQUIRED_INSTALLER)
	set(CPACK_NSIS_DEFINES "RequestExecutionLevel admin")
else()
	set(CPACK_NSIS_DEFINES "RequestExecutionLevel user")
endif()
include(CPack)

###############################
## Setup convenience scripts ##
###############################
if(WIN32)
    configure_file(${CMAKE_SOURCE_DIR}/../scripts/reconfig.bat.in
               ${CMAKE_BINARY_DIR}/reconfig.bat
               @ONLY)
    configure_file(${CMAKE_SOURCE_DIR}/../scripts/build.bat.in
               ${CMAKE_BINARY_DIR}/build.bat
               @ONLY)
    configure_file(${CMAKE_SOURCE_DIR}/../scripts/make_install.bat.in
               ${CMAKE_BINARY_DIR}/make_install.bat
               @ONLY)
    configure_file(${CMAKE_SOURCE_DIR}/../scripts/make_install_debug.bat.in
               ${CMAKE_BINARY_DIR}/make_install_debug.bat
               @ONLY)
else()
    configure_file(${CMAKE_SOURCE_DIR}/../scripts/reconfig.sh.in
               ${CMAKE_BINARY_DIR}/reconfig.sh
               @ONLY)
    configure_file(${CMAKE_SOURCE_DIR}/../scripts/build.sh.in
               ${CMAKE_BINARY_DIR}/build.sh
               @ONLY)
    configure_file(${CMAKE_SOURCE_DIR}/../scripts/make_install.sh.in
               ${CMAKE_BINARY_DIR}/make_install.sh
               @ONLY)
    configure_file(${CMAKE_SOURCE_DIR}/../scripts/make_install_debug.sh.in
               ${CMAKE_BINARY_DIR}/make_install_debug.sh
               @ONLY)
endif()
