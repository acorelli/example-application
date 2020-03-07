#!/usr/bin/env bash

# Configures a dependent shared library of a Mach-O binary (executable or shared library) to use
# RPATH. Adds the shared library path to the RPATH of the binary, then prepends @rpath/ to the
# shared libary's install name.

if [[ $# -ne 2 ]] || ! [[ -f $1 ]] || ! [[ $1 = /* ]] || ! [[ -f $2 ]]; then
  echo "Usage: configure_dependency_rpath dependency target"
  echo "  dependency - the absolute path to the shared library dependency"
  echo "  target - the Mach-O binary (executable or shared library) that is being linked to"
  exit 1
fi

# If the path to the library hasn't been added to the RPATH listing in the
# target binary, then add it
library_directory=$(dirname "$1")
rpaths=$(otool -l $2 | grep -A2 LC_RPATH)
if [[ $library_directory != *"$rpaths"* ]]; then
  install_name_tool -add_rpath $library_directory $2
fi

# If the library hasn't already been prepended with RPATH, i.e.,
# @rpath/libfoo.dylib, then prepend it
library_filename=$(basename "$1")
rpath_already_appended=$(otool -L $2 | grep "@rpath/$library_filename")
if [[ -z $rpath_already_prepended ]]; then
  install_name_tool -change $library_filename @rpath/$library_filename $2
fi
