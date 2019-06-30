#!/usr/bin/env python
"""A script to help with fiddling with things.

Usage:
    truss [-d | --debug] (download | dl)
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
    version_string = "{} {}".format(
        AppConfig.meta.application,
        AppConfig.meta.version
    )
    arguments = docopt(__doc__, version=version_string)
    logger.info("Starting %s CLI", AppConfig.meta.application)

    if arguments['--debug']:
        logging.getLogger(__name__).setLevel(logging.DEBUG)

        for key, value in arguments.items():
            logger.debug("cli_arg: %s: %s", key, value)

        logger.debug("Application configuration:")
        config_strings = AppConfig.get_printable_string()
        for config_string in config_strings:
            logger.debug("app_config: %s", config_string)


if __name__ == "__main__":
    main()