My-ope office](http://www.my-ope.net/)という社内問合せ特化のAIチャットBotサービスのリポジトリです。

## 開発環境構築
画面側はRails,Botエンジン部分がPythonで書かれており、チャット部分や学習に関わる処理を動かす際には、Python側のRPCサーバを起動する必要があります。

```
$ git clone git@github.com:mofmof/donusagi-bot.git
$ cd donusagi-bot
$ bundle install
$ rake db:migrate
$ rake db:seed_fu
```

### React開発環境構築

一部の画面でReactを使用しています。  
ソースコードは `app/assets/javacripts/es2015` 以下にあります。  
ビルド後のソースは `app/assets/javascripts/bundled-2015.js` です。

__jsライブラリのインストール__

```
$ npm install -g yarn
$ yarn install
$ yarn add ライブラリ名 # 新しいライブラリを追加する場合
```

__jsのビルド__

```
$ npm run watch # 開発時
$ npm run build # 本番公開前に
```

---

TODO mecabなどのインストール

参考: http://tech.mof-mof.co.jp/blog/scikit-learn.html

```
$ brew install mecab
$ brew install mecab-ipadic
```


Pythonのライブラリをインストール。pyenv,virtualenvを使っています。

```
$ cd learning
$ pyenv virtualenv 3.5.2 donusagi-bot3
$ pip install -r requirements.txt
```


## 開発時

Railsのサーバを起動

```
$ rails s
```

delayed_jobの起動(学習処理をバックグラウンドで処理しているため必要)

```
$ rake jobs:work
```

python側のRPCサーバ起動

```
$ cd learning
$ python myope_server.py
```

## 機械学習エンジン側(Python)
### 開発時の実行方法
通常は`myope_server.py`を起動するが、学習処理や予測処理を個別に走らせるようのスクリプトもあります。

学習処理を単体で実行する

```
$ cd learning
$ python learn.py
```

予測処理を単体で実行する

```
$ cd learning
$ python predict.py
```

## テストの実行について
### Rails側(Guard)

feature testはPython側エンジンと連携してテストする必要があるため、specを実行する前にtestモードでRPCサーバを起動する。

```
$ cd learning
$ python myope_server.py test
$ cd ..
$ guard
```

※ テスト実行中にPython側でエラーが発生するとrspecがストップしてしまう問題があります。その際はPython側RPCサーバを停止するとrspecが流れます。

### Python側のユニットテスト実行方法

```
$ cd learning
$ nosetests learning/tests
```

#### 機械学習エンジンのテスト

前処理・後処理を含めてRails経由でテストする方法はテスト実行に非常に時間がかかってしまうため、チューニング作業する際に時間をロスしてしまう。そのため。nosetestsを使って機械学習エンジンの振る舞いをテスト出来るようにしています。`learning/learning/tests/engine`配下に当該のテストが実装されています。

教師データは本番環境から手動で取得する必要があります。RailsAdminの管理画面から、取得したいBotのLearningTrainingMessageのcsvをエクスポートし、`learning/learning/tests/engine/fixtures`にファイルを配置することで、直接csvファイルから学習処理を走らせることが出来ます。

ファイル例）
```
id,question,answer_body,answer_id
1,こんにちは,はい、こんにちは元気ですか？,11
2,明日天気はなんですか？,明日は晴れるでしょう！,12
```

※`learning/learning/tests/engine/fixtures`配下のファイルを参照してください。
※RailsAdminのエクスポート機能でデフォルトで出力されるヘッダーと文言が異なるので注意
※エクスポートファイルはShift-JISでエクスポートすること

## デプロイ
### Capistrano

```
$ cap production deploy
```

### Ansible

```
$ ansible-playbook -i ansible/production ansible/web-servers.yml -u a.harada --ask-sudo-pass
```

## 画面上に導線のない画面のURL
- 同義文登録画面: http://localhost:3000/bots/:bot_id/sentence_synonyms/new
- 同義文一覧画面: http://localhost:3000/bots/:bot_id/sentence_synonyms
