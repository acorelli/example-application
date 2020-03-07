#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

ThirdPartyDir=$1
if [ "$ThirdPartyDir" == "" ]
then
	echo "Default 3rd Party directory /usr/local/ being used"
	ThirdPartyDir=/usr/local/
else
	echo "Using $ThirdPartyDir as 3rd Party directory"
fi

echo "Setting up 3rd Party Libraries & Utilities"
echo "Fetching dependencies..."

(cd $DIR/../scripts/ && ./brew_dependencies.sh 2>/dev/null)

# Set QT dir for homebrewed version
export Qt5_DIR=/usr/local/opt/qt/lib/cmake/Qt5/

# Remove CMake-generated files that should be regenerated
declare -a CMakeGeneratedFiles=("CMakeCache.txt" \
                                "build.sh" \
                                "make_install.sh" \
                                "reconfig.sh")
for CMakeGeneratedFile in "${CMakeGeneratedFiles[@]}"; do
    CMakeGeneratedFileFullPath=$DIR/$CMakeGeneratedFile
    [ ! -e $CMakeGeneratedFileFullPath ] || rm -f $CMakeGeneratedFileFullPath
done

echo "Configuring project files..."
cmake -G"Xcode" -DCMAKE_PREFIX_PATH=$ThirdPartyDir -DCMAKE_INSTALL_PREFIX=./install $DIR/../src
