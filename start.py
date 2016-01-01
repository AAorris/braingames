#!/usr/bin/env python
import os
import sys
from subprocess import call as shell
from subprocess import Popen as proc
from shlex import split as lex

path = os.path.abspath("dist/electron.exe".replace("/", os.path.sep))

def main():
    isposix = (os.name == "posix")
    sys.stdout.write("\n\rStarting Electron... ")
    sys.stdout.write(path)
    shell(path, isposix)

if __name__ == '__main__':
    main()
