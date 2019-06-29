#!/usr/bin/env python
"""A script to help with fiddling with things.

Usage:
  truss (-d | --debug)
  truss (-h | --help)
  truss (-v | --version)

Options:
  -d, --debug    Show debug output and exit.
  -h, --help     Show this screen.
  -v, --version  Show version.
"""
from .appconfig import AppConfig
from docopt import docopt


def main():
    version_string = "{} {}".format(AppConfig.application, AppConfig.version)
    arguments = docopt(__doc__, version=version_string)
    print(arguments)
