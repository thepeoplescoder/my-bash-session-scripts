# my-bash-session-scripts

[![View on GitHub](https://img.shields.io/badge/Bash%20Session%20Scripts-Repo-blue?logo=github)](https://github.com/thepeoplescoder/my-bash-session-scripts)

## What's this Project About?
I needed a way to keep my `~/.bashrc` and `~/.bash_profile` organized.

## Installation

### Assumptions
For simplicity, the rest of this file assumes that this repository will be cloned in `~/.bash_session_scripts`.

### How to Install
The install script will create backups of `~/.bashrc`, `~/.bash_profile`, and `~/.bash_logout` before overwriting them:

1. In a new terminal window:
   ```sh
   git clone https://github.com/thepeoplescoder/my-bash-session-scripts ~/.bash_session_scripts
   cd ~/.bash_session_scripts
   ./install-scripts/install
   ```
2. Restart your terminal.

### Post-Install State
You will notice that `~/.bashrc`, `~/.bash_profile`, and `~/.bash_logout` will be overwritten to contain one line of code `source`ing their corresponding file inside of `~/.bash_session_scripts`, surrounded by a line of whitespace on top and on bottom.

### A Summary of How Everything Works
Each session script (`.bashrc`, `.bash_profile`, `.bash_logout`) inside of `~/.bash_session_scripts` corresponds to a `.d` directory also located within:

* `.bashrc` corresponds to `bashrc.d`
* `.bash_profile` corresponds to `bash_profile.d`
* `.bash_logout` corresponds to `bash_logout.d`

And each script does the same thing:

* Each script looks in its corresponding directory, and *only* looks at the visible directories in lexicographical order.
   * For each of these directories, each visible file (and only each visible file) is examined in lexicographical order.  If it is executable, then it is ran as an executable file.  Otherwise, the file's extension is looked at, and based on the files in `~/.bash_session_scripts/extensions-to-runners`, an appropriate command is used to run the file.

How executables are processed will be explained in another section.

## Post Install: Getting Started
If you run the installation script and launch a new terminal window, you'll see some text notifying you of what scripts are being loaded.  On a fresh install, you'll see names of sections (directories) for each script, but you'll notice no scripts are running.

Most of everything you will need to get started will be located in `~/.bash_session_scripts/examples/for/`.  In there, you should see directories that correspond to each startup script:
* bash_profile.d
   * 555-555-main
   * 999-999-final
* bashrc.d
   * 000-000-pre-initial
   * 001-000-initial
   * 555-555-main
   * 999-000-pre-final
   * 999-999-final

On a new install, you will notice that `~/.bash_profile` sources both
`~/.profile` and `~/.bashrc`.  This is because `~/.bash_session_scripts/bash_profile.d/`
now contains the file that does the sourcing.  Users no longer have to perform
the step of manually copying or symlinking the file to that location.

### Windows Users Running Cygwin/MSYS2 - Enabling Symlinks
Make sure you have Developer mode turned on to enable symbolic links without
needing to have Administrator access.  Then make sure `~/.windows_cygwin_msys2_options` exists
and contains the text
```
winsymlinks:nativestrict
```
Any text in `~/.windows_cygwin_msys2_options` will be used as the value for `$MSYS` or `$CYGWIN`
as appropriate, as your environment is detected on shell startup.