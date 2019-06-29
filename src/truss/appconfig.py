# IMPORTANT(coenie): Do *NOT* use any modules outside the standard libraries in
# this file or the world as we know it will end.


class DictObject(dict):
    """A class that can be defined and accessed as a class. See:
    https://goodcode.io/articles/python-dict-object/
    """
    def __getattr__(self, name):
        if name in self:
            return self[name]
        else:
            error = "No such attribute: {}".format(+ name)
            raise AttributeError(error)

    def __setattr__(self, name, value):
        self[name] = value

    def __delattr__(self, name):
        if name in self:
            del self[name]
        else:
            error = "No such attribute: {}".format(+ name)
            raise AttributeError(error)


AppConfig = DictObject()
AppConfig.application = "truss"
AppConfig.version = "0.0.1"
