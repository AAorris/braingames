#!/usr/bin/env python
import os
import sys
from subprocess import call as shell
from subprocess import Popen as proc
from shlex import split as lex

copy_command = {
"posix": "cp -rf ./node_modules/electron-prebuild/dist dist",
"mac": "cp -rf ./node_modules/electron-prebuild/dist dist",
"nt": "xcopy /S /Y .\\\\node_modules\\\\electron-prebuilt\\\\dist dist\\\\",
}

def main():
    isposix = (os.name == "posix")
    sys.stdout.write("\n\rCopying files...")
    cmd = lex(copy_command[os.name])
    shell(cmd, isposix)

if __name__ == '__main__':
    main()
