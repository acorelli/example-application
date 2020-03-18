# CMakeLists.txt to build example-module dependency from source_group
cmake_minimum_required(VERSION 3.11.0 ) # FetchContent introduced in 3.11.0


include(FetchContent)
FetchContent_Declare(example-module
	GIT_REPOSITORY	git@github.com:acorelli/example-module.git
	GIT_TAG develop
	GIT_SHALLOW YES
)

set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME example-module)


if(NOT example-module_POPULATED)
	set(FETCHCONTENT_EXAMPLE_MODULE YES)
	FetchContent_Populate(example-module)
	add_subdirectory(
		${example-module_SOURCE_DIR}/src
		${example-module_BINARY_DIR}
	)
endif()

set_target_properties(example-module PROPERTIES
	FOLDER example-module
)
