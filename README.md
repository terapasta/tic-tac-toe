[My-ope office](http://www.my-ope.net/)という社内問合せ特化のAIチャットBotサービスのリポジトリです。

※Python側の開発に関わる情報は[wiki](https://github.com/mofmof/donusagi-bot/wiki/Python%E5%81%B4%E3%81%AE%E9%96%8B%E7%99%BA%E3%81%AB%E9%96%A2%E3%82%8F%E3%82%8B%E6%83%85%E5%A0%B1)を参照ください。

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

## テストの実行について

feature testはPython側エンジンと連携してテストする必要があるため、specを実行する前にtestモードでRPCサーバを起動する。

```
$ cd learning
$ python myope_server.py test
$ cd ..
$ guard
```

※ テスト実行中にPython側でエラーが発生するとrspecがストップしてしまう問題があります。その際はPython側RPCサーバを停止するとrspecが流れます。

## デプロイ
### Capistrano

```
$ cap production deploy
```

### Ansible

```
$ ansible-playbook -i ansible/production ansible/web-servers.yml -u a.harada --ask-sudo-pass
```
