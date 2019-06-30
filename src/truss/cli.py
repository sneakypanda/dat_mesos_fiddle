#!/usr/bin/env python
"""A script to help with fiddling with things.

Usage:
    truss [-d | --debug] pkg
    truss (-d | --debug)
    truss (-h | --help)
    truss (-v | --version)

Options:
  -d, --debug    Show debug output and exit.
  -h, --help     Show this screen.
  -v, --version  Show version.
"""
import logging
import logging.config
from .appconfig import AppConfig
from docopt import docopt

logging.config.dictConfig(AppConfig.logging)
logger = logging.getLogger(__name__)


def main():
    version_string = "{} {}".format(AppConfig.application, AppConfig.version)
    arguments = docopt(__doc__, version=version_string)
    logger.info("Starting %s CLI", AppConfig.application)

    if arguments['--debug']:
        logging.getLogger(__name__).setLevel(logging.DEBUG)

        logger.debug("Command line arguments:")
        for key, value in arguments.items():
            logger.debug("%s: %s", key, value)

        logger.debug("Application configuration:")
        for conf_key, conf_value in AppConfig.items():
            if isinstance(conf_value, dict):
                for key, value in conf_value.items():
                    logger.debug("%s.%s: %s", conf_key, key, value)
            else:
                logger.debug("%s: %s", conf_key, conf_value)

