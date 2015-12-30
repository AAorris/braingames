"""Brain Game - Memorizing Numbers"""

import os
from subprocess import call
from textwrap import dedent
from random import randrange
from time import sleep
from sys import stdin, stdout, stderr
from collections import defaultdict

def wipe():
    os.system('cls' if os.name == 'nt' else 'clear')

def clear(width=30):
    """clears the terminal line
    TODO: get terminal width using sys/os"""
    stdout.write("\r%s\r" % (" " * width))
    stdout.flush()

class Score(object):
    def __init__(self):
        self.wins = 0
        self.losses = 0
    @property
    def value(self):
        if self.losses == 0:
            if self.wins == 0:
                return 0.0
            return 1.0
        else:
            return self.wins / self.losses
    def score(self, condition):
        if condition:
            self.wins += 1
        else:
            self.losses += 1
    def __str__(self):
        return "<Score %d/%d (%1d%)>" % (self.wins, self.losses, self.value)

class BGMemNum(object):
    __config__ = {
        "flashtime": 0.5,
        "delaytime": 0.5,
        "playdelay": 1.0,
        "startlevel": 2,
        "winthreshold": 0.8
    }
    def __init__(self):
        for key, val in self.__config__.items():
            setattr(self, key, val)
        self.scores = defaultdict(Score) # score per level
        self.level = self.startlevel

    def report(self):
        score = self.scores[self.level].value
        threshold = self.winthreshold
        stdout.write("score {score} / {threshold}\n".format(**locals()))
        stdout.flush()

    def challenge(self):
        test = [str(randrange(0, 9)) for n in range(self.level)]
        for number in test:
            clear()
            stdout.write(number)
            stdout.flush()
            sleep(self.flashtime)
            clear()
            sleep(self.delaytime)
            clear()
        return "".join(test)

    @property
    def finished(self):
        return False

    def play(self):
        input("press enter to continue...")
        wipe()
        truth = self.challenge()
        given = input("\ranswer: ")
        result = (given == truth)
        self.scores[self.level].score(result)
        if result:
            stdout.write("correct.\n")
            if self.scores[self.level].value > self.winthreshold:
                self.report()
                stdout.write("proceeding to level %d\n" % (self.level + 1))
                stdout.flush()
                self.level += 1
        else:
            stdout.write("incorrect. answer was %s.\n" % truth)
            self.report()
        sleep(self.playdelay)

def main():
    game = BGMemNum()
    while not game.finished:
        game.play()

if __name__ == '__main__':
    main()
