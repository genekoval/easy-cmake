# Easy CMake

A collection of handy modules for Modern CMake.

## Usage

This repo is meant to be used as a Git submodule. First, add it to your project:

```bash
git submodule add $REMOTE_URL cmake/easy-cmake
```

Then, add a `cmake/modules.cmake` file for adding this and any other modules
to your `CMAKE_MODULE_PATH`:

```cmake
unset(CMAKE_MODULE_PATH)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/easy-cmake")
```

Finally, include this file in your `CMakeLists.txt`, preferably at the beginning
after the `cmake_minimum_required` command:

```cmake
include(cmake/modules.cmake)
```

After that, you may include individual modules as needed. For example, to
use the closest Git tag as your project version, add something like the
following to your `CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.27)

include(cmake/modules.cmake)
include(GitVersion)

project(example
    VERSION ${GIT_VERSION_ABBREV}
    DESCRIPTION "An example CMake project using easy-cmake"
)
```

## Modules

### CPackGitIgnore

Generates a value for the `CPACK_SOURCE_IGNORE_FILES` variable based on the
project's `.gitignore` file. It also adds Git-related files and folders
such as `.git` and `.gitmodules`.

### EasyInstall

Provides the `easy_install` macro, which takes care of a lot of the boilerplate
needed to generate installation rules for the project. It writes config and
version files, exports the package so it is available for other packages to
use during development, and sets up CPack for generating a tarball for
distribution. This macro accepts two multi-value arguments:

- `TARGETS`: A list of targets to install.
- `DEPENDENCIES`: A list of external dependencies the targets require.

### GitVersion

Reads the project version from the most recent Git tag that begins with `v`.
This module removes the need for hard coding the version in `CMakeLists.txt`.
Including this module results in the following two variables being defined:

- `GIT_VERSION_FULL`: The Git tag with the leading `v` stripped out and possibly
  the current commit's hash. See `git help describe` for more information.
- `GIT_VERSION_ABBREV`: The closest Git tag with the leading `v` stripped out.

If Git is not available, the project has no Git tags, or the `.git` directory is
missing as in the case of a tarball, the module will look for a `VERSION` file
in the root of the project and attempt to read the version from there. In this
case, both `GIT_VERSION_FULL` and `GIT_VERSION_ABBREV` will be set to the value
read from the `VERSION` file.

Finally, if the above methods did not produce a version, a default of `0.0.0`
will be used.

### ProjectTesting

Enables the `PROJECT_TESTING` variable and includes CTest if certain conditions
are met. In your `CMakeLists.txt`, you may then put all testing code inside
a conditional check of this variable. For example:

```cmake
include(ProjectTesting)

if(PROJECT_TESTING)
    add_executable(example.test "")

    target_link_libraries(example.test
        PRIVATE
            GTEST::gtest_main
            example
    )

    add_test("Unit Tests" example.test)
endif()
```

### Sanitizers

Provides the `enable_asan` function which adds address sanitizer compiler flags
to debug builds.
