from abc import ABCMeta, abstractmethod

class Base(metaclass=ABCMeta):
    @abstractmethod
    def build(self):
        pass

    @property
    def x(self):
        return self._x

    @x.getter
    def x(self):
        return self._x

    @property
    def y(self):
        return self._y

    @y.getter
    def y(self):
        return self._y
