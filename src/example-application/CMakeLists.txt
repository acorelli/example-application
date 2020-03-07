# CMakeLists.txt for example-application

# VS_DEBUGGER_ENVIRONMENT target property introduced in 3.13
cmake_minimum_required(VERSION 3.13)

add_executable(example-application "")
set(application_icon_files
    $<$<CXX_COMPILER_ID:MSVC>:
        ${CMAKE_CURRENT_SOURCE_DIR}/rc/icon.ico
        ${CMAKE_CURRENT_SOURCE_DIR}/rc/icon.rc
    >
)
target_compile_options(example-application
	PRIVATE $<$<CXX_COMPILER_ID:MSVC>:
	        	/experimental:external
	        	/external:I ${CMAKE_PREFIX_PATH} # Suppress all external header
	        	/external:W0                     # warnings
	        	/W4 /WX # Enable warning levels 0-4, treat as errors
	        	/wd4193 # Ignore C4193 warnings generated when using
	        >           # /experimental:external. This is a bug known to MS.
	        $<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:GNU>>:
	        	-W -Wall -Wextra -pedantic -Werror
	        >
)
target_link_options(example-application
	PRIVATE 
		$<$<CXX_COMPILER_ID:MSVC>:
			# Ignore C4099 warnings generated when linking to third-party 
			# libraries without debugging symbols
			/ignore:4099
		>
)
# NOTE: Everything is included here as a __TEST__ (Remove as necessary when cleaning up project)
# Only need to include directories for the non- <project>Targets.cmake style libraries
target_include_directories(example-application
    PRIVATE
		$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>
		$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
		$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include> # Export header
		#$<INSTALL_INTERFACE:include>
)

target_link_libraries(example-application
    PRIVATE example-module
)

# Minizip Linkage if needed
#if(WIN32 AND MSVC)
#	target_link_libraries(application PRIVATE ZLIB::zlib)
#else()
#	target_link_libraries(application PRIVATE ZLIB::ZLIB)
#endif()

target_sources(example-application
	PRIVATE ${application_icon_files}
            ${CMAKE_CURRENT_LIST_DIR}/src/main.cpp
)
set(EXE_NAME "example-application")
set_target_properties(example-application PROPERTIES
	ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
	CXX_EXTENSIONS           NO
	CXX_STANDARD             17
	CXX_STANDARD_REQUIRED    YES
	DEBUG_POSTFIX            d
	FOLDER                   org/example-application
	OUTPUT_NAME              ${EXE_NAME}
	RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
	SOVERSION                ${PROJECT_VERSION}
	VERSION                  ${PROJECT_VERSION}
)

source_group("Application Icon Files" FILES ${application_icon_files})

install(
	TARGETS             example-application example-module
	RUNTIME DESTINATION bin
)

# Create a convenience target to run the application executable
set(run_target run)
if(MSVC)
    set(run_target RUN)
endif()
add_custom_target(${run_target}
    COMMAND
        ${CMAKE_COMMAND} -E
        env " \"${vs_debugger_environment}" \" $<TARGET_FILE:example-application>
    DEPENDS example-application
)
set_property(TARGET ${run_target}
    PROPERTY
    FOLDER CustomTargets
)
set_property(
    TARGET example-application
    PROPERTY
    VS_DEBUGGER_ENVIRONMENT ${vs_debugger_environment}
)
