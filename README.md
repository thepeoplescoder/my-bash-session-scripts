# my-bash-session-scripts

[![View on GitHub](https://img.shields.io/badge/Bash%20Session%20Scripts-Repo-blue?logo=github)](https://github.com/thepeoplescoder/my-bash-session-scripts)

## What's this Project About?
I needed a way to keep my `~/.bashrc` and `~/.bash_profile` organized.

## Installation
The install script will create backups of `~/.bashrc`, `~/.bash_profile`, and `~/.bash_logout` before overwriting them:

1. In a new terminal window:
   ```sh
   git clone https://github.com/thepeoplescoder/my-bash-session-scripts ~/.bash_session_scripts
   cd ~/.bash_session_scripts
   ./install-scripts/install
   ```
2. Restart your terminal.

## Post Installation
After installation, you will notice that `~/.bashrc`, `~/.bash_profile`, and `~/.bash_logout` will be overwritten to contain one line of code `source`ing their corresponding file inside of `~/.bash_session_scripts`, surrounded by a line of whitespace on top and on bottom.

## How Everything Works

Each session script (`.bashrc`, `.bash_profile`, `.bash_logout`) inside of `~/.bash_session_scripts` corresponds to a `.d` directory:

* `.bashrc` corresponds to `bashrc.d`
* `.bash_profile` corresponds to `bash_profile.d`
* `.bash_logout` corresponds to `bash_logout.d`

And each script does the same thing:

* Each script looks in its corresponding directory, and *only* looks at the visible directories in lexicographical order.
   * For each of these directories, each visible file (and only each visible file) is examined in lexicographical order.  If it is executable, then it is ran as an executable file.  Otherwise, the file's extension is looked at, and based on the files in `~/.bash_session_scripts/extensions-to-runners`, and appropriate command is used to run the file.

How executables are processed will be explained in another section.