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
$ cp learning/learning/config/config.yml.example learning/learning/config/config.yml
```

## 開発サーバー起動
railsとworkerとBotエンジンを起動する必要があります。
普通にコンソールを３つ開いてもいいですが、Foremanを使うと比較的楽です

```
$ bundle exec forman start
```

※railsは [localhost:3838](http://localhost:3838) で起動します

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
$ npm run build # git commit前 & 本番公開前に
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

## Slack 連携
### Slack bot サーバー立ち上げ
```
$ cd slack-bot
$ bundle exec slappy start
```
### 開発用デバッグBOTの設定
Slack連携はCustom Botとしてslackに登録したBotユーザーデータを利用して行います。

1. https://my.slack.com/services/new/botにアクセスしCustom bot userを作成する。
2. ENV['SLACK_TOKEN']に取得したAPI Tokenを設定する。環境変数のセットにはdotenv gemが利用できます。
3. https://slack.com/api/users.list?pretty=1&token={取得したAPI Token}を実行して、登録したCustom bot userのidを表示、slappy_config.rbのconfig.robot.bot_idに指定する。

以上でslack連携を行うことができるようになります。


## Coudwatch Logsの設定

__参考__

- http://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/logs/QuickStartEC2Instance.html
- http://qiita.com/aidy91614/items/bafcce212effe66455db

__/etc/awslogs/awslogs.conf 設定内容__

```
[/var/www/donusagi-bot/shared/log/delayed_job.log]
datetime_format = %b %d %H:%M:%S
file = /var/www/donusagi-bot/shared/log/delayed_job.log
buffer_duration = 5000
log_stream_name = {instance_id}
initial_position = start_of_file
log_group_name = /var/www/donusagi-bot/shared/log/delayed_job.log

[/var/www/donusagi-bot/shared/log/production.log]
datetime_format = %b %d %H:%M:%S
file = /var/www/donusagi-bot/shared/log/production.log
buffer_duration = 5000
log_stream_name = {instance_id}
initial_position = start_of_file
log_group_name = /var/www/donusagi-bot/shared/log/production.log

[/var/www/donusagi-bot/shared/log/slappy.log]
datetime_format = %b %d %H:%M:%S
file = /var/www/donusagi-bot/shared/log/slappy.log
buffer_duration = 5000
log_stream_name = {instance_id}
initial_position = start_of_file
log_group_name = /var/www/donusagi-bot/shared/log/slappy.log

[/var/www/donusagi-bot/shared/log/unicorn.stderr.log]
datetime_format = %b %d %H:%M:%S
file = /var/www/donusagi-bot/shared/log/unicorn.stderr.log
buffer_duration = 5000
log_stream_name = {instance_id}
initial_position = start_of_file
log_group_name = /var/www/donusagi-bot/shared/log/unicorn.stderr.log

[/var/www/donusagi-bot/shared/log/unicorn.stdout.log]
datetime_format = %b %d %H:%M:%S
file = /var/www/donusagi-bot/shared/log/unicorn.stdout.log
buffer_duration = 5000
log_stream_name = {instance_id}
initial_position = start_of_file
log_group_name = /var/www/donusagi-bot/shared/log/unicorn.stdout.log
```

__logrotate__

```
/var/www/donusagi-bot/shared/log/*.log {
  daily
  create 0644 deploy deploy
  rotate 7
  missingok
  compress
  delaycompress
  copytruncate
  notifempty
}
```
