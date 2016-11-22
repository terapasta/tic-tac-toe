class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        '''
        Args:
            cls:        クラスオブジェクト
            args:       Singletonインスタンスにリスト型等を分解して渡す引数
            kwargs:     Singletonインスタンスに辞書型を分解して渡す引数

        Returns:
            Singletonインスタンス
        '''
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)

        return cls._instances[cls]
