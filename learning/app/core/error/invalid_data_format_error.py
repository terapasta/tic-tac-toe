class InvalidDataFormatError(Exception):
    """
    InvalidDataFormatError
    """
    def __init__(self, expected, message):
        self.expected = expected
        self.message = message
