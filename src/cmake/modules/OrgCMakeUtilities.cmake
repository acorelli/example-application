function(org_append_to_rpath dependent_libraries target)
    # Configures a dependent library of a target (shared library or executable)
    # to use @rpath in its install name, and adds the path to the library to
    # the rpaths recorded in the target.

    # Currently, only Mach-O binaries on macOS are supported.

    # Inputs:
    # dependent_libraries: a list of dependent libraries. These can be a
    #                      combination of IMPORTED targets or full paths to
    #                      libraries.
    # target:              the CMake target that depends on the library (shared
    #                      library or executable)
    if(APPLE)
        add_custom_command(
            TARGET target
            POST_BUILD
            COMMAND
                ${CMAKE_CURRENT_LIST_DIR}/configure_dependency_rpath.bash
                dependent_library
                $<TARGET_FILE:target>
        )
    endif()
endfunction()
