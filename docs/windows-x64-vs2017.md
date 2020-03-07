# `Visual Studio 15 2017 Win64` Setup and build instructions
  
  
## 0. Install prerequisites
* [Git :link:](https://git-scm.com)
* [CMake :link:](https://cmake.org) (latest version)
* Microsoft Visual Studio 2017


## 1. Download source code  
```batchfile
git@url.to.the.repo.server:path/products/example-product-environment/example-application.git
```
Clone this project to a location on your computer; this will be the 
`<project_dir>`.  

## 2. Choose directories  
Choose directories for the following:  
* Build artifacts (`<build_dir>`)  
* Third-party dependencies (`<third_party_dir>`)  
* Installed files (`<install_dir>`)  
  
  
## 3. Configure and build

### Easy configuration (recommended)  
Run the `easy_config.bat` script from the desired `<build_dir>`. By default, it 
will place the third-party dependencies in 
`<third_party_dir> = <build_dir>/3rdParty`, and set 
`<install_dir> = <build_dir>/install`.  The script will automatically 
clone/update the third-party dependencies and configure the project using 
the appropriate paths.  

:information_source: Note: this will take some time to clone libraries the 
first time it's called.
  
You may also call `easy_config.bat` and provide a `<third_party_dir>` argument 
to specify a different folder for the third-party libraries.

Once the script has finished, you can start developing by opening 
`example-application.sln`, which launches the project in Visual Studio. You can build 
the project in Visual Studio, or simply run `build.bat` from the command line 
to build the debug and release configurations and generate documentation files. 

Run `run_tests.bat` and verify that all of the tests pass. Finally, run 
`make_install.bat` to create the example-application installer executable.  
  
:information_source: If files are added/removed and the project needs to be 
reconfigured, `reconfig.bat` can be called to generate the updated CMake 
configuration *without* syncing the third-party libraries.  
  
### Manual configuration
The easy configuration automates many of the steps required to configure and 
build the project. For a detailed step-by-step guide to building example-application, see
[here :link:](docs/windows-x64-vs2017-manual-config.md).

  
## 4. Troubleshooting  
  
### 4.1. Errors  
If errors are discovered, please create bug tickets on the project JIRA page.
  
  
## 5. Jenkins Builds  
  
### 5.1. Triggering a Build  
Builds will be triggered automatically when the develop branch is updated.

To request Jenkins build a feature branch, comment:  
  
```
jenkins please try a build
```  
  
in its merge request.  
