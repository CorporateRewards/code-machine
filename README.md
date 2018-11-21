# code-machine

## Intro
Code Machine is the ideal code management system.

## Installation
Code Machine Script has been written for use on minimal Debian systems, such as TurnKey.<br />
If errors are encountered when installing modules, use aptitude to resolve dependency conflicts.<br />
ie, ```sudo aptitude install nodejs;```<br />

## Usage
USAGE: ```./_code-machine.sh [help|install|force-install|update|start|debug|stop|clear]```<br />

- help
    - shows the help message
- install
    - prepares server installation, only installs missing modules (work in progress)
- force-install
    - prepares server installation, forcing updates of existing modules (work in progress)
- update
    - updates server app dependencies (gems)
- start
    - starts the server in the background with no stdout
- debug
    - starts the server in debug mode, with verbose stdout
- restart
    - restarts the server in the background with no stdout
- stop
    - kills all associated pids
- clear
    - clears app cache