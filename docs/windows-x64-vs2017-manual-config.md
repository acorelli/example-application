## Manual configuration  

### 0. Choose directories  
This guide assumes you have already selected directories for the following:  
* Build artifacts (`<build_dir>`)  
* Third-party dependencies (`<third_party_dir>`)  
* Installed files (`<install_dir>`)  

### 1. Fetch third-party dependencies and utilities
example-application is configured to use the following third-party dependencies:  
  
**Library Name**   | **Tag**  | **Repo URL** :link:
:--                | ---:     | :---
doxygen            | *1.8.14* | [path/doxygen](http://url.to.the.repo.server/path/doxygen)
graphviz           | *1.02*   | [path/graphviz](http://url.to.the.repo.server/path/graphviz/)
NSIS               | *3.01*   | [path/NSIS](http://url.to.the.repo.server/path/nsis)
qt                 | *5.9.2*  | [path/qt](http://url.to.the.repo.server/path/qt/)

:information_source: Other versions of the above libraries may work but are 
not known to work.

Prebuilt binaries are available using the following fetch script:
```batchfile
cd <project_dir>\scripts
.\fetch_dependencies.cmd <third_party_dir>
```  
:information_source: Note: this will take some time to clone libraries the 
first time it's called.

### 2. Configure
```batchfile
mkdir <build_dir>
cd <build_dir>
cmake -G "Visual Studio 15 2017 Win64" <project_dir>\src 
-DCMAKE_PREFIX_PATH=<third_party_dir> -DCMAKE_INSTALL_PREFIX=<install_dir>
```

### 3. Build
```batchfile
cmake --build <build_dir> --config Debug
cmake --build <build_dir> --config Release
```

### 4. Run the tests
To run unit tests for builds, ensure that the project is built, then run the 
following:
```batchfile
cmake --build <build_dir> --config Debug --target RUN_TESTS_MSVC
cmake --build <build_dir> --config Release --target RUN_TESTS_MSVC
```
Note that CMake also generates a target called RUN_TESTS. This should not be 
used, as this will run the tests without verbose output, making it difficult
to pinpoint any failed test cases.

If everything goes well, after testing each configuration you should see the 
message `100% tests `{+passed+}`, 0 tests `{-failed-}` out of ##`
  
:information_source: Note: paths to third-party binary directories must be set 
in the `PATH` environment variable or the tests will {-FAIL-}.  

### 5. Build the documentation
```batchfile
cmake --build <build_dir> --config Release --target DOCS
```
The API documentation will be placed in `<build_dir>\docs\html`. Open 
`index.xhtml` to view the documentation.

### 6. Create the installer
```batchfile
git clone --depth 1 git@url.to.the.repo.server:path/products/example-product-environment/example-application.git -b develop
cd <build_dir>
<project_dir>\build\easy_config.bat <third_party_dir>
.\make_install.bat
```
This will pull the latest commit from the `develop` branch, build the optimized 
binaries, collect all runtime dependencies and support files, and put them into
an installer application.  
  
:information_source: If you're working from an existing checkout of the 
project, simply run `make_install.bat` from the `<build_dir>`.  
  

The intermediate products will be placed in the `<install_dir>` and the 
compressed installer executable will be generated in the `<build_dir>`.  
