# `Xcode` Setup and build instructions
  
  
## 0. Install prerequisites
* [Git :link:](https://git-scm.com)
* [CMake :link:](https://cmake.org) (latest version)
* Xcode (tested with version 10.0)


## 1. Download source code  
```bash
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

```bash
cd ~/Documents/Github/path
git clone git@url.to.the.repo.server:path/products/example-product-environment/example-application.git -b develop
cd example-application/build
./easy_config.sh ~/Documents/Github/path
```
The `easy_config.sh` script runs from the desired `<build_dir>`. By default, 
it places the third-party dependencies in 
`<third_party_dir> = ~/Documents/Github` and sets
`<install_dir> = <build_dir>/install`.  The script automatically clone/updates 
the third-party dependencies and configures the project using the appropriate 
paths.  
  
You may also call `easy_config.sh` and provide a `<third_party_dir>` argument 
to specify a different folder for the third-party libraries.

To open the project in Xcode and start developing, use the following command:
```bash
open example-application.xcodeproj
```
You can build the project in Xcode, or simply run `build.sh` from the terminal 
to build the debug and release configurations and generate documentation files.
  
Run `run_tests.sh` and verify that all of the tests pass. Finally, run 
`make_install.sh` to create the **example-application** installer executable.  
  
:information_source: If files are added/removed and the project needs to be 
reconfigured, `reconfig.sh` can be called to generate the updated CMake 
configuration *without* syncing the third-party libraries.  
  
### Manual configuration
The easy configuration automates many of the steps required to configure and 
build the project. For a detailed step-by-step guide to building **example-application**, see
[here :link:](docs/macos-x64-xcode-manual-config.md).
  
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
