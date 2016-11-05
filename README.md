## WEB側(Rails)
TODO

## 機械学習エンジン側(Python)
### 開発時の実行方法
```
$ cd learning
$ python learn.py
```

## テストの実行について(Guard)

python側エンジンと連携してテストする必要があるため、specを実行する前にtestモードでRPCサーバを起動する。

```
$ cd learning
$ python myope_server.py test
$ guard
```
