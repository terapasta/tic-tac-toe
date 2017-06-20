## Elasticsearch

### AWSを使えるかどうか

AWSのElasticsearch Serviceはマネージドプラグイン以外を使うことができない。

http://localhost:8888/tree?token=ceb766ff67e9e2ca4d4ade3af36adb46282d063519545a5a

利用可能なプラグイン

- Japanese (kuromoji) Analysis
  - 形態素解析
- ICU Analysis
  - Unicodeとグローバリゼーションのサポートを提供する
- Phonetic Analysis
  - トークンを音声表現に変換する
- Smart Chinese Analysis
  - 中国語の形態素解析
- Stempel Polish Analysis
  - Lucineのstempelモジュールを使えるらしい
- Ingest Attachment Processor
  - XLSやPDFのためのもの?
- Ingest User Agent Processor
  - ユーザーエージェント解析?
- Mapper Murmur3
  - インデックスを使いやすくする?


類似検索、ランク学習などに関係するようなものはなさそう。
結果、ひとまずインストールして自由にプラグインカスタマイズしながら使うのが良さそう。

### ローカルにインストールして使う

プラグイン候補
- https://github.com/sdauletau/elasticsearch-position-similarity
- https://github.com/MLnick/elasticsearch-vector-scoring


#### データを取り込む

indexを一から設計して作るのは適当に動かすだけにしても大変そうだ

DBからいい感じに取り込めないか

↓

https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model

これ使ってみる。
