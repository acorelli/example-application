# doxygen_add_docs introduced in 3.9.6
cmake_minimum_required(VERSION 3.9.6 FATAL_ERROR)

# TODO: This is not a very portable way to find Doxygen, but it seems to be
# the only way to get CMake to find it. Also, the variables
# DOXYGEN_EXECUTABLE and DOXYGEN_DOT_EXECUTABLE are deprecated.
if(WIN32)
	set(Doxygen_DIR ${CMAKE_PREFIX_PATH}/doxygen)
	set(DOXYGEN_EXECUTABLE ${CMAKE_PREFIX_PATH}/doxygen/doxygen.exe)
	set(DOXYGEN_DOT_EXECUTABLE ${CMAKE_PREFIX_PATH}/graphviz/bin/dot.exe)
endif(WIN32)

find_package(Doxygen REQUIRED dot QUIET)

set(DOXYGEN_CALL_GRAPH           YES)
set(DOXYGEN_CALLER_GRAPH         YES)
set(DOXYGEN_CLASS_DIAGRAMS       YES)
set(DOXYGEN_CLASS_GRAPH          YES)
set(DOXYGEN_COLLABORATION_GRAPH  YES)
set(DOXYGEN_DOT_GRAPH_MAX_NODES  100)
set(DOXYGEN_DOT_IMAGE_FORMAT     svg)
set(DOXYGEN_DOT_TRANSPARENT      YES)
set(DOXYGEN_EXTRACT_ALL          YES)
set(DOXYGEN_HAVE_DOT             YES)
set(DOXYGEN_HTML_FILE_EXTENSION  .xhtml)
set(DOXYGEN_INTERACTIVE_SVG      YES)
set(DOXYGEN_MAX_DOT_GRAPH_DEPTH  0)
set(DOXYGEN_RECURSIVE            YES)
set(DOXYGEN_TEMPLATE_RELATIONS   YES)
set(DOXYGEN_UML_LIMIT_NUM_FIELDS 50)
set(DOXYGEN_UML_LOOK             YES)
set(DOXYGEN_WARN_LOGFILE         ${CMAKE_CURRENT_BINARY_DIR}/DoxygenWarnings.txt)

set(docs_target docs)
if(MSVC)
	set(docs_target DOCS)
endif()
doxygen_add_docs(${docs_target}
	${PROJECT_SOURCE_DIR}
	COMMENT "Generating API documentation using Doxygen..."
)
set_property(TARGET ${docs_target} 
	PROPERTY
	FOLDER OrgGroupCustomTargets
)
