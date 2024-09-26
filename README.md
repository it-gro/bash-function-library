Main / [Usage](#usage) / [Libraries](#libraries) / [Functions](docs/function-list.md) / [Installation](docs/installation.md) / [Description](docs/description.md) / [Coding](docs/coding-standards.md) / [Constants](#Constants) / [Error handling](docs/error-handling.md) / [Tests](#tests) / [Templates](#templates) / [Examples](#examples) / [Docs](#documentation) / [ToDo](#todo)

## Bash Function Library (collection of utility functions)

A collection of BASH utility functions and script templates used to ease the creation of portable and hardened BASH scripts with sane defaults.<br />
Main source bash functions repository: https://github.com/AlexeiKharchev/bash_functions_library
I load these up in my own shell environment.<br />
If they're useful for anyone else, then great! :)<br />
If you see some errors or have improvements, you can discuss it within Telegram group Bash_functions_library

#### This project is copied from several bash functions projects with the similar approach.
#### Sourced git repositories I have got ideas, templates, tests and examples to current project:
| Author | weblink | comment |
|:---:|---|:---:|
| **Joe Mooring** | [https://github.com/jmooring/bash-function-library](https://github.com/jmooring/bash-function-library) | (is **not** POSIX compliant) |


### Usage

In short:<br />
1) clone repository: `git clone git@github.com:AlexeiKharchev/bash_functions_library "$YOUR_PATH"`<br />
2) create script to define repository locaton (in order ro source from any script):<br />
**Contents of my `${HOME}/getConsts` :**
```bash
set -o allexport  # == set -a Enable using full option name syntax
...................... some directory declarations ......................
readonly BASH_FUNCTIONS_LIBRARY='/etc/bash_functions_library/autoload.sh'
.........................................................................
readonly myPython='python3.8'
readonly myPerl='5.30.0'
readonly localPythonModulesDir="/home/alexei/.local/lib/$myPython/site-packages"
.........................................................................
set +o allexport  # == set +a Disable using full option name syntax
```
3) source ${HOME}/getConsts in /etc/profile (or some autoload script in /etc/profile.d)<br />
```bash
# plug in external library
[[ ${_GUARD_BFL_AUTOLOAD} -eq 1 ]] || { . ${HOME}/getConsts || exit 1; . "${BASH_FUNCTIONS_LIBRARY}"; }
echo "${DarkGreen}Loading /etc/profile${NC}"
```
4) run terminal and type `bfl::string_of_char 'A' 50`<br />
Your should see `AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA` in terminal
5) Now you can use `Bash Functions Library` in your scripts like .profile (step 3).<br />
As a result, `getConsts` will be loaded no more than once.<br />
In order to handle errors there is declaration `trap 'bfl::trap_cleanup ...` in `autoload.sh`,<br />
so you need not to additionally declare `trap`.<br />
Log file declared in `autoload.sh`:    `readonly BASH_FUNCTIONS_LOG="$HOME/.faults"`


### Libraries

The libraries are located in diectories within `lib/` and contain BASH functions which can be used in your scripts.
Each included function includes detailed usage information. Read the inline comments within the code for detailed usage instructions.

|    Library   |      Description     |     |    Library   |  Description   |
|    :---:     |         :---:        | :-: |     :---:    |      :---:     |
|   strings    |     Bash Strings     |     |              |                |
|     file     |                      |     |     mail     |                |
|   directory  |                      |     |              |                |
|     date     |                      |     |              |                |
|   numbers    |         mail         |     |   passwords  |   UUID, etc    |
|      url     |   url conversation   |     |              |                |
|   directory  |                      |     |      sms     |                |
| declaration  | colors, other consts |     |              |                |
|  procedures  | (for internal using) |     |              |                |

#### libraries for specific usage:

| Debian | Git | Apache | Maven | Lorem | Nexus |
|:---:|:---:|:---:|:---:|:---:|:---:|
|  |  |  | Apache Maven build tool |  | Sonatype Nexus software repository manager |


### Templates

Use [_library_function.sh](templates/_library_function.sh) for writing new functions.

|                         Library                        |                                          Description                                              |
|:------------------------------------------------------:|---------------------------------------------------------------------------------------------------|
| [_library_function.sh](templates/_library_function.sh) | Use to add some new function, in order to make coding simplier and folow unified coding standards |
| [script](templates/script)                             | Use to create a script which leverages the Bash Function Library                                  |


### Constants
#### Global constants

Alerting constants are declared in [consts](consts) from [Natelandau](https://github.com/natelandau/shell-scripting-templates).<br />
Basic terminal colors are declared in functions [_declared_terminal_colors.sh](lib/_declared_terminal_colors.sh) and [_declare_ansi_escape_sequences.sh](lib/_declare_ansi_escape_sequences.sh) from [JMooring](https://github.com/jmooring/bash-function-library).<br />
Global variables for available dependencies indicating are loaded at [autoload.sh](autoload.sh) last rows by calling [bfl::global_declare_dependencies](lib/procedures/_global_declare_dependencies.sh).<br />

The following **global variables** must be set for the alert functions to work:
| var | description | default |
|:---:|---|:---:|
| **`${BASH_INTERACTIVE}`** | If `false`, prints to log file but not stdout | `true` |
| **`${BASH_CHECK_DEPENDENCIES_STATICALLY}`** | If `true`, doesn't check for tool exists every time | `true` |
| **`${DEBUG}`** | If `true`, prints `debug` level alerts to stdout | `false` |
| **`${VERBOSE}`** | If `true` prints all debug messages to stdout | `false` |
| **`${DRYRUN}`** | If `true` does not eval commands passed to `_execute_` function | `false` |
| **`${BASH_COLOURED}`** | Disable coloured output. If `false`, command `tput` also needs var `$TERM` | `true` |
| **`${BASH_FUNCTIONS_LOG}`** | Path to a log file | `"$HOME/.faults"` |
| **`${BASH_LOG_LEVEL}`** | One of: `FATAL`, `ERROR`, `WARN`, `INFO`, `DEBUG`, `ALL`, `OFF` | `ERROR` |

Print messages to stdout and to a user specified logfile using the following functions.<br />
```bash
warning "some text"   # Non-critical warnings
error "some text"     # Prints errors and the function stack but does not stop the script.
debug "some text"     # Printed only when in verbose (-v) mode
   ... etc ...
```

#### Temporary variables

Temporary variables in scripts:
| var | description |
|:---:|---|
| **`${_bfl_temporary_var}`** | Used in almost every `_.sh` script header |
| **`${SPIN_NUM}`** | Used in `_terminal_spinner.sh` |
| **`${PROGRESS_BAR_PROGRESS}`** | Used in `_terminal_progressbar.sh` |

### The main script `autoload.sh` is roughly split into three sections:
#### I. TOP: Description, options and global variables:
These default options are included in the templates and used throughout the utility functions. CLI flags to set/unset them are:
- **`-h, --h, --help`**: Prints the contents of the `_usage_` function. Edit the text in that function to provide help
- **`--logfile [FILE]`** Full PATH to logfile. (Default is `${HOME}/logs/$(basename "$0").log`)
- **`loglevel [LEVEL]`**: Log level of the script. One of: `FATAL`, `ERROR`, `WARN`, `INFO`, `DEBUG`, `ALL`, `OFF` (Default is '`ERROR`')
- **`-n, --dryrun`**: Dryrun, sets `$DRYRUN` to `true` allowing you to write functions that will work non-destructively using the `_execute_` function
- **`-q, --q, --quiet`**: Runs in quiet mode, suppressing all output to stdout. Will still write to log files
- **`-v, --verbose`**: Sets `$VERBOSE` to `true` and prints all debug messages to stdout
- **`--force`**: If using the `bfl::wait_confirmation` utility function, this skips all user interaction. Implied `Yes` to all confirmations.
#### II. MIDDLE:
- **function `bfl::parseOptions`** You can add custom script options and flags to this function.
#### III. BOTTOM:
- **Script initialization** `bfl::autoload` is at the bottom of the `autoload.sh`. Uncomment or change the settings before `bfl::autoload` for your needs.
Write the main logic of your script within the `_mainScript_` function. It is placed at the bottom of the file for easy access and editing.It is invoked at the end of the script after options are parsed and functions are sourced.


### Examples

|                       Example                     |                                              Description                                              |
|:-------------------------------------------------:|-------------------------------------------------------------------------------------------------------|
| [examples/\_introduce.sh](examples/_introduce.sh) | This library function is simple and heavily&mdash; documented tutorial                                |
| [examples/session-info](examples/session-info)    | This script leverages the Bash Function Library, displaying a banner with user and system information |


### Tests

[JMooring](https://github.com/jmooring/bash-function-library) uses not so flexible as [BATS](https://github.com/sstephenson/bats), but is smart and tiny.

### Documentation

|                       Docs                      |                Description                |
|:-----------------------------------------------:|-------------------------------------------|
| [coding-standards.md](docs/coding-standards.md) | Coding standards                          |
| [function-list.md](docs/function-list.md)       | Summary of library functions              |
| [error-handling.md](docs/error-handling.md)     | Notes on error handling                   |
| [functions-list.md](docs/functions-list.md)     | Is not updated yet                        |


### License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


### ToDo

* make function script for build help about all functions
* combine and [JMooring testing system](https://github.com/jmooring/bash-function-library/blob/master/test/test) and [Bash Automated Testing System (BATS)](https://github.com/sstephenson/bats)
