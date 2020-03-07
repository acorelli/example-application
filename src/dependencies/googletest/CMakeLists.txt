# CMakeLists.txt to build the Google Test dependency from source
cmake_minimum_required(VERSION 3.11.0) # FetchContent introduced in 3.11.0

include(FetchContent)
FetchContent_Declare(googletest
	GIT_REPOSITORY https://github.com/google/googletest.git
	GIT_TAG        release-1.10.0
	GIT_SHALLOW    YES
)
if(NOT googletest_POPULATED)
	FetchContent_Populate(googletest)
	add_subdirectory(
		${googletest_SOURCE_DIR} 
		${googletest_BINARY_DIR}
	)
endif()

set_directory_properties(PROPERTIES EXCLUDE_FROM_ALL YES)

# Ignore undef warnings, issue with source file:
# googletest/include/gtest/internal/gtest-port.h:309:5: error: "_MSC_VER" is 
# not defined
if(NOT MSVC)
	add_compile_options(-Wno-undef)
endif()

# Prevent Google Test from overriding our compiler/linker options
# when building with Visual Studio
set(gtest_force_shared_crt YES CACHE BOOL "" FORCE)
set(BUILD_SHARED_LIBS NO)

# Define googletest as a component so we have the option to exclude it when 
# packaging MMDA
set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME googletest)

set(BUILD_GMOCK YES)
set(BUILD_GTEST YES)

# Keep the CMake cache variable list clean
mark_as_advanced(
    BUILD_GMOCK BUILD_GTEST BUILD_SHARED_LIBS
    gmock_build_tests gtest_build_samples gtest_build_tests
    gtest_disable_pthreads gtest_force_shared_crt gtest_hide_internal_symbols
)

# Remove after switching to Google Test version 1.8.1
target_compile_definitions(gtest PUBLIC 
	$<$<AND:$<CXX_COMPILER_ID:MSVC>,$<VERSION_GREATER_EQUAL:$<CXX_COMPILER_VERSION>,1900>>:
		_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING
	>
)
target_compile_definitions(gtest_main PUBLIC 
	$<$<AND:$<CXX_COMPILER_ID:MSVC>,$<VERSION_GREATER_EQUAL:$<CXX_COMPILER_VERSION>,1900>>:
		_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING
	>
)
target_compile_definitions(gmock PUBLIC
	$<$<AND:$<CXX_COMPILER_ID:MSVC>,$<VERSION_GREATER_EQUAL:$<CXX_COMPILER_VERSION>,1900>>:
		_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING
	>
)
target_compile_definitions(gmock_main PUBLIC
	$<$<AND:$<CXX_COMPILER_ID:MSVC>,$<VERSION_GREATER_EQUAL:$<CXX_COMPILER_VERSION>,1900>>:
		_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING
	>
)

set_target_properties(gmock gmock_main gtest gtest_main PROPERTIES 
	FOLDER org/${PROJECT_PREFIX}/third_party_dependencies/googletest
)