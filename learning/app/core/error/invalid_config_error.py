class InvalidConfigError(Exception):
    """
    InvalidConfigError
    """
    def __init__(self, message):
        self.message = message
