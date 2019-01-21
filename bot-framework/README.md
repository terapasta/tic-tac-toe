# Bot Framework を用いたボットの開発手順

## 前提知識

### Bot Framework とは

Bot Framework は、Microsoft社より提供されているボット開発用のフレームワークである。
https://dev.botframework.com/

Azure とは独立して開発されているため、AWS や GCP上にデプロイすることもできるが、
Azure はこの Bot Framework とシームレスに連携する Bot Service というサービスを提供しており、
本稿では基本的に Azure上にデプロイする前提で説明する。

### Bot Service とは

Bot Service は、Azure上でホスティングされている C# または node.js の実行環境である。
https://azure.microsoft.com/ja-jp/services/bot-service/

開発者はどちらかの言語を選択できるが、以降では基本的に node.js を選択したこととする。


## Azure へのデプロイ

### 準備

Bot Service では Azure の App Service（インスタンス）の環境変数を引き継げる。
これにより、`.env` などで環境変数を渡さなくても、安全にトークンやパスワードを設定できる。
設定が必要な環境変数は、以下の通りである。

- `BOT_TOKEN` ... MyOpe API側で Bot を指定するためのトークン。`bots`テーブルの `token` を指定する。
- `MYOPE_API_URL` ... MyOpe API の URL。

### デプロイ

本ファイルがあるディレクトリで、以下のコマンドを実行すると Azure にデプロイできる。

```bash
$ npm run azure-publish
```

ただし、デプロイ時には以下の環境変数を指定する必要がある。

- `AZURE_PROJECT_NAME` ... Bot Service のプロジェクト名（デプロイユーザー名と同じにする）
- `AZURE_PROJECT_PASSWORD` ... Azure上で デプロイ資格情報として登録したデプロイユーザーのパスワード

※ デプロイ資格情報
https://portal.azure.com/#@mofmofmof.onmicrosoft.com/resource/subscriptions/bf89d567-1d35-44a4-8711-30c28c404fa8/resourceGroups/myope-dev/providers/Microsoft.Web/sites/myope-dev/deploymentcredentials
