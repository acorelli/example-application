## Manual configuration

### 0. Choose directories  
This guide assumes you have already selected directories for the following:
* Source code (`<project_dir>`)
* Build artifacts (`<build_dir>`)  
* Third-party dependencies (`<third_party_dir>`)  
* Installed files (`<install_dir>`)  

### 1. Fetch third-party dependencies and utilities
**example-application** is configured to use the following third-party dependencies:  
  
**Library Name**    | **Version** | Source
:---                | ---:        | :---
doxygen             | latest      | [Homebrew](https://brew.sh/)
graphviz            | latest      | [Homebrew](https://brew.sh/)
NSIS                | latest      | [Homebrew](https://brew.sh/)
qt                  | latest      | [Homebrew](https://brew.sh/)

:information_source: Other versions of the above libraries may work but are not 
known to work.

Most of the dependencies are available on the Homebrew package manager. We can 
fetch those dependencies using the following script:
```bash
cd <project_dir>/scripts/ && ./brew_dependencies.sh
```

We will save the paths to a few dependencies for the configuration step:
```
QT_DIR=/usr/local/opt/qt/lib/cmake/Qt5/
```

### 2. Configure
```bash
mkdir -p <build_dir>
cmake -G Xcode -DCMAKE_PREFIX_PATH=/usr/local/ -DCMAKE_INSTALL_PREFIX=./install -DQt5_DIR=$QT_DIR $DIR/ <project_dir>/src
```
 
### 3. Build
```bash
cmake --build <build_dir> --config Debug
cmake --build <build_dir> --config Release
```

### 4. Run the tests
To run unit tests for builds, ensure that the project is built, then run the 
following:
```bash
ctest -C Debug -VV
ctest -C Release -VV
```
If everything goes well, after testing each configuration you should see the 
message `100% tests `{+passed+}`, 0 tests `{-failed-}` out of ##`

### 5. Build the documentation
```bash
cmake --build <build_dir> --config Release --target docs
```
The API documentation will be placed in `<build_dir>/docs/html`. Open 
`index.xhtml` to view the documentation.

### 6. Create the installer
Creating an installer is not currently supported.
