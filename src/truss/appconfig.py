# IMPORTANT(coenie): Do *NOT* use any modules outside the standard libraries in
# this file or the world as we know it will end.
import logging
import os


class DictObject(dict):
    """A class that can be defined and accessed as a class. See:
    https://goodcode.io/articles/python-dict-object/
    """

    def __getattr__(self, name):
        if name in self:
            return self[name]
        else:
            error = "No such attribute: {}".format(name)
            raise AttributeError(error)

    def __setattr__(self, name, value):
        self[name] = value

    def __delattr__(self, name):
        if name in self:
            del self[name]
        else:
            error = "No such attribute: {}".format(name)
            raise AttributeError(error)

    def get_printable_string(self, parent_value=""):
        """Return a string of the option as a key/value pair."""
        printable_strings = []
        for key, value in self.items():
            if parent_value:
                out_key = "{}.{}".format(parent_value, key)
            else:
                out_key = "{}.{}".format("AppConfig", key)
            if isinstance(value, DictObject):
                cnf_str = value.get_printable_string(parent_value=out_key)
                printable_strings += cnf_str
            else:
                cnf_str = "{}.{}: {}".format(out_key, key, value)
                printable_strings += [cnf_str, ]
        return printable_strings


home_dir = os.environ['HOME']
local_dir = os.path.join(os.environ['HOME'], ".local")

# General configuration
AppConfig = DictObject()
AppConfig.meta = DictObject()
AppConfig.meta.application = "truss"
AppConfig.meta.version = "0.0.1"

# Paths configuration
AppConfig.paths = DictObject()
AppConfig.paths.base_name = "{}-{}".format(
    AppConfig.meta.application,
    AppConfig.meta.version
)
AppConfig.paths.home_dir = os.environ['HOME']
AppConfig.paths.local_dir = os.path.join(os.environ['HOME'], ".local")
AppConfig.paths.dl = os.path.join(
    home_dir,
    "Downloads",
    AppConfig.paths.base_name
)
AppConfig.paths.work_dir = os.path.join(local_dir, "wrk")

# Downloads base configuration
AppConfig.dl = DictObject()
AppConfig.dl.base_url = "https://archive.apache.org/dist"
AppConfig.dl.app_url = "{base_url}/{application}/{version}".format(
    base_url=AppConfig.dl.base_url,
    application=AppConfig.meta.application,
    version=AppConfig.meta.version
)
AppConfig.dl.keys_url = "{base_url}/{application}".format(
    base_url=AppConfig.dl.base_url,
    application=AppConfig.meta.application
)

# Downloads files configuration
AppConfig.dl.files = DictObject()

# Archive dl config
AppConfig.dl.files.archive = DictObject()
AppConfig.dl.files.archive.filename = "{base_name}.tar.gz".format(
    base_name=AppConfig.paths.base_name
)
AppConfig.dl.files.archive.dst = "{downloads}/{file}".format(
    downloads=AppConfig.paths.dl,
    file=AppConfig.dl.files.archive.filename
)
AppConfig.dl.files.archive.src = "{app_url}/{file}".format(
    app_url=AppConfig.dl.app_url,
    file=AppConfig.dl.files.archive.filename
)
# Signature dl config
AppConfig.dl.files.signature = DictObject()
AppConfig.dl.files.signature.filename = "{archive}.asc".format(
    archive=AppConfig.dl.files.archive.filename
)
AppConfig.dl.files.signature.dst = "{downloads}/{file}".format(
    downloads=AppConfig.paths.dl,
    file=AppConfig.dl.files.signature.filename
)
AppConfig.dl.files.signature.src = "{app_url}/{file}".format(
    app_url=AppConfig.dl.app_url,
    file=AppConfig.dl.files.signature.filename
)
# Digests dl config
AppConfig.dl.files.digests = DictObject()
AppConfig.dl.files.digests.filename = "{archive}.sha512".format(
    archive=AppConfig.dl.files.archive.filename
)
AppConfig.dl.files.digests.dst = "{downloads}/{file}".format(
    downloads=AppConfig.paths.dl,
    file=AppConfig.dl.files.digests.filename
)
AppConfig.dl.files.digests.src = "{app_url}/{file}".format(
    app_url=AppConfig.dl.app_url,
    file=AppConfig.dl.files.digests.filename
)
# Keys dl config
AppConfig.dl.files.sig_keys = DictObject()
AppConfig.dl.files.sig_keys.filename = "KEYS"
AppConfig.dl.files.sig_keys.dst = "{downloads}/{file}".format(
    downloads=AppConfig.paths.dl,
    file=AppConfig.dl.files.sig_keys.filename
)
AppConfig.dl.files.sig_keys.src = "{keys_url}/{file}".format(
    keys_url=AppConfig.dl.keys_url,
    file=AppConfig.dl.files.sig_keys.filename
)

# Logging config
AppConfig.logging = DictObject(
    {
        "version": 1,
        "formatters": {
            "console": {
                "format": "%(levelname)s: %(message)s"
            },
            "syslog": {
                "format": (
                    "%(asctime)s: %(name)s: %(filename)s:%(lineno)d:"
                    " %(levelname)s: %(message)s"
                )
            },
        },
        "handlers": {
            "console": {
                "class": "logging.StreamHandler",
                "formatter": "console",
                "level": logging.DEBUG,
            },
            "syslog": {
                "class": "logging.handlers.SysLogHandler",
                "formatter": "syslog",
                "level": logging.DEBUG,
                "address": "/dev/log"
            }
        },
        "loggers": {
            "": {
                "handlers": ["console", "syslog"],
                "level": logging.INFO,
                "propagate": True
            },
        }
    }
)
