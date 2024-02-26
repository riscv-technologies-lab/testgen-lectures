# Environment and shell variables

An environment variable is a variable whose value is set outside the program,
typically through functionality built into the operating system or microservice.
An environment variable is made up of a name/value pair, and any number may be
created and available for reference at a point in time.

In all Unix and Unix-like systems, as well as on Windows, each process has its
own separate set of environment variables. By default, when a process is created,
it inherits a duplicate run-time environment of its parent process, except for
explicit changes made by the parent when it creates the child. Alternatively,
from command shells such as bash, a user can change environment variables for a
particular command invocation by indirectly invoking it via `env` or using the
`ENVIRONMENT_VARIABLE=VALUE <command>` notation. A running program can access the
values of environment variables for configuration purposes.

Shell scripts and batch files use environment variables to communicate data and
preferences to child processes. They can also be used to store temporary values
for reference later in a shell script. However, in Unix, non-exported variables
are preferred for this as they do not leak outside the process.

In Unix, an environment variable that is changed in a script or compiled program
will only affect that process and possibly child processes. The parent process
and any unrelated processes will not be affected. Similarly, changing or removing
a variable's value inside a DOS or Windows batch file will change the variable
for the duration of COMMAND.COMor CMD.EXE's existence, respectively.

In Unix, the environment variables are normally initialized during system startup
by the system init startup scripts, and hence inherited by all other processes in
the system. Users can, and often do, augment them in the profile script for the
command shell they are using. In Microsoft Windows, each environment variable's
default value is stored in the Windows Registry or set in the AUTOEXEC.BAT file.

In general, the collection of environment variables function as an associative
array where both the keys and values are strings. The interpretation of
characters in either string differs among systems. When data structures such as
lists need to be represented, it is common to use a colon (common on Unix and
Unix-like) or semicolon-delineated (common on Windows and DOS) list.

Most of common environment variables used by a Linux system and their values:

- `PATH` contains a colon-separated list of directories in which your system
  looks for executable files. When a regular command (e.g. ls, cat, vim) is
  interpreted by the shell (e.g. `bash`), the shell looks for an executable file
  with the same name as your command in the listed directories, and executes it.
  To run executables that are not listed in `PATH`, a relative or absolute path
  to the executable must be given, e.g. `./a.out` or `/bin/ls`.
- `USER` contains the current user name.
- `HOME` contains the path to the home directory of the current user. This
  variable can be used by applications to associate configuration files and such
  like with the user running it.
- `PWD` contains the path to the working directory.
- `TERM` contains the type of the running terminal, e.g. `xterm-256color`. It is
  used by programs running in the terminal that wish to use terminal-specific
  capabilities.
- `SHELL` contains the path to the user's preferred shell. Note that this is not
  necessarily the shell that is currently running. In the event that it has no
  value, Bash will automatically set this variable to the user's login shell as
  defined in `/etc/passwd` or to `/bin/sh` if this cannot be determined.
- `EDITOR` contains the command to run the lightweight program used for editing
  files, e.g., `/usr/bin/vim` or `/usr/bin/nano`.

## Usage

The variables can be used both in scripts and on the command line. They are
usually referenced by putting special symbols in front of or around the variable
name.

It is conventional for environment-variable names to be chosen to be in all
upper cases. In programming code generally, this helps to distinguish environment
variables from other kinds of names in the code. Environment-variable names are
case sensitive on Unix-like operating systems but not on DOS, OS/2, and Windows.

In most Unix and Unix-like command-line shells, an environment variable's value
is retrieved by placing a $ sign before the variable's name. If necessary, the
name can also be surrounded by braces.

### How to get environment variable value in shell

You can check all environment variables that are set in current shell via `env`
command. To get value of a specific environment use `$` with variable name:
`$HOME` -- this will be substituted with variable value. To print this value just
use `echo`:

```sh
echo $HOME
```

### How to set envitonment variable in shell

You can set environment variable with `export` command:

```sh
export VAR=NAME
```

Note: `VAR=NAME` works, `VAR = NAME` doesn't.

### How to set environment variable for only one process

Use `env` command to set environment variable for only one process:

```sh
env EDITOR=vim git config -e
```

### How to store environment variables in a file

You can store envitonment variables in shell scripts (these files are usually
named as `env.sh`):

```sh
#!/bin/bash

VAR1=VALUE1
VAR2=VALUE2
VAR3=VALUE3
```

And then to use them in your shell or another script you need 'import' them with
`source` command:

```sh
source env.sh
```
