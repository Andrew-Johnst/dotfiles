# My Configuration Files and Some Helper Scripts Used across My Machines.
- Easily commit changes to and install the files that are tracked in this repository from/on any machine.

## Mainly using this as an insurance policy/off-site backup and to install on my other computers.

- This repository is primarily just intended for my own off-site backups, but the 'bin/tc' (truecolors) script
is very handy for testing different $TERM color modes, and whether or not truecolor/24bit color
is active and if your terminal is capable of 24bit color mode.

- The specific declarations of the $TERM variable in .zshrc, and setting default-terminal settings
in .tmux.conf were very finicky getting to work properly with 24bit color mode specifically
retaining the settings in tmux sessions, however every terminal emulator I've run the tc script on
has worked with the current configurations (except for urxvt/rxvt-unicode due to the way it
approximates to 256 colors).

##  Usage of ```ezgit``` Bootstrapping Script:
  ```bash
  ./ezgit {[-i | --install] || [-u | --upload]} | {[-f | --fast ]} | {[-h | --help]}
  ```
* ```[ -i | --install ]```
  * Pulls remote files from git repository into current git directory, then copies files to local machine in the operrating user's home directory.

* ```[ -u | --upload ]```
  * Copies the files and directories listed in the ```FILELIST``` list variable containing files and directories to copy from the local machine to the current git directory, then push those files to the remote reopsitory.

* ```[ -f | --fast ]```
  * Skips creating a backup of either the files currently locally installed or the remote git repository.
    * Backups of local files are located in: ```/tmp/BACKUPS/Local/$DATE```
    * Backups of theh remote (git repository) are located in: ```/tmp/BACKUPS/Remote/$DATE```

* ```[ -h | --help]```
  * Prints the help/usage message and exits.

## The ```ezgit``` script can only either install or upload at a single time/execution.
- The "fast" option ```[ -f | --fast ]``` may be combined/used with either of the two other functions of the script here:
  - ```[ -i | --install ]```
    - This just bypasses the function in the bootstrap script that would create a compressed tarball of the files already present on the machine.
    - Applying the ```-f``` "fast" option to this script action is risky since any files in this repository that are also present on the machine executing this script, will have them overwritten without creating a backup first.

  - ```[ -u | --upload ]```
    - Applying the ```-f``` to the ```[ -u | --upload ]``` carries far less risks than when installing, since any undesireable commits can be ameliorated via a git reset or git revert.

## Example of the ```ezgit``` script:
  - The following command will copy all the files and directories listed in the ```FILELIST``` variable in the ```ezgit``` script to the local git directory, then stage them to be committed.
  ```bash
  ./ezgit -i -f
  ```
- The above command will run the install function via the ```-i``` option, and will bypass/ignore creating any local backups of the files to be replaced with the installation via the ```-f``` or "fast" option.
- The inverse of this command (upload) via the: ```-u``` option can also be passed the ```-f``` option to negate local backups.
