from injector import Injector, AssistedBuilder


class BaseCls:
    @classmethod
    def new(cls, **args):
        # Note: DIされたインスタンスを生成する
        builder = Injector().get(AssistedBuilder[cls])
        return builder.build(**args)
