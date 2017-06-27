## Elasticsearch (以下ES)

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

question_answerをESに取り込む

```
pry$ QuestionAnswer.all.map {|x| x.__elasticsearch__.index_document }
```

ESに対して以下を実行する (kibanaから実行可能)

```
GET question_answers/_search
{
  "query":{
    "match_all" : {}
  }
}
```

データが入っていることが確認できた

### QuestionAnswerのレコードから似ているレコードを探す

```
[24] pry(main)> q.more_like_this.results.map(&:question)
=> ["オフィスはどこにある？", "会社はどこにある？", "どこから問い合わせすればいい？"]
[25] pry(main)>
[26] pry(main)>
[27] pry(main)> q = QuestionAnswer.first
  QuestionAnswer Load (1.2ms)  SELECT  `question_answers`.* FROM `question_answers`  ORDER BY `question_answers`.`id` ASC LIMIT 1
=> #<QuestionAnswer:0x007fad7f2e4cb0
 id: 1,
 bot_id: 1,
 question: "オフィスはどこにあるの？",
 answer_id: 2,
 underlayer: nil,
 created_at: Tue, 27 Jun 2017 08:53:36 JST +09:00,
 updated_at: Tue, 27 Jun 2017 08:53:36 JST +09:00,
 selection: false>
[28] pry(main)> q.more_like_this.results.map(&:question)
=> ["オフィスはどこにある？", "会社はどこにある？", "どこから問い合わせすればいい？"]
[29] pry(main)>
```

似ていそうなものが取れている

### プラグイン試す
- https://github.com/MLnick/elasticsearch-vector-scoring


```
FROM elasticsearch:5.3

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
                    git \
                    maven \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget https://github.com/MLnick/elasticsearch-vector-scoring/archive/master.zip \
        -O elasticsearch-vector-scoring.zip \
    && unzip elasticsearch-vector-scoring.zip \
    && mvn package

WORKDIR /usr/share/elasticsearch
RUN elasticsearch-plugin  install --batch x-pack
RUN elasticsearch-plugin  install analysis-kuromoji
RUN elasticsearch-plugin  install file:///tmp/elasticsearch-vector-scoring.zip
```

```
mvn package -e
[INFO] Error stacktraces are turned on.
[INFO] Scanning for projects...
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] Building elasticsearch-vector-scoring 5.3.0
[INFO] ------------------------------------------------------------------------
[INFO]
[INFO] --- maven-resources-plugin:2.3:resources (default-resources) @ elasticsearch-vector-scoring ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 1 resource
[INFO]
[INFO] --- maven-compiler-plugin:2.3.2:compile (default-compile) @ elasticsearch-vector-scoring ---
[INFO] Compiling 2 source files to /tmp/elasticsearch-vector-scoring-master/target/classes
[INFO] -------------------------------------------------------------
[ERROR] COMPILATION ERROR :
[INFO] -------------------------------------------------------------
[ERROR] Unable to locate the Javac Compiler in:
  /usr/lib/jvm/java-8-openjdk-amd64/jre/../lib/tools.jar
Please ensure you are using JDK 1.4 or above and
not a JRE (the com.sun.tools.javac.Main class is required).
In most cases you can change the location of your Java
installation by setting the JAVA_HOME environment variable.
[INFO] 1 error
[INFO] -------------------------------------------------------------
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 1.567s
[INFO] Finished at: Tue Jun 27 03:24:22 UTC 2017
[INFO] Final Memory: 13M/154M
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:2.3.2:compile (default-compile) on project elasticsearch-vector-scoring: Compilation failure
[ERROR] Unable to locate the Javac Compiler in:
[ERROR] /usr/lib/jvm/java-8-openjdk-amd64/jre/../lib/tools.jar
[ERROR] Please ensure you are using JDK 1.4 or above and
[ERROR] not a JRE (the com.sun.tools.javac.Main class is required).
[ERROR] In most cases you can change the location of your Java
[ERROR] installation by setting the JAVA_HOME environment variable.
[ERROR] -> [Help 1]
org.apache.maven.lifecycle.LifecycleExecutionException: Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:2.3.2:compile (default-compile) on project elasticsearch-vector-scoring: Compilation failure
Unable to locate the Javac Compiler in:
  /usr/lib/jvm/java-8-openjdk-amd64/jre/../lib/tools.jar
Please ensure you are using JDK 1.4 or above and
not a JRE (the com.sun.tools.javac.Main class is required).
In most cases you can change the location of your Java
installation by setting the JAVA_HOME environment variable.

	at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:213)
	at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:153)
	at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:145)
	at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:84)
	at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:59)
	at org.apache.maven.lifecycle.internal.LifecycleStarter.singleThreadedBuild(LifecycleStarter.java:183)
	at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:161)
	at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:320)
	at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:156)
	at org.apache.maven.cli.MavenCli.execute(MavenCli.java:537)
	at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:196)
	at org.apache.maven.cli.MavenCli.main(MavenCli.java:141)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:289)
	at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:229)
	at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:415)
	at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:356)
Caused by: org.apache.maven.plugin.CompilationFailureException: Compilation failure
Unable to locate the Javac Compiler in:
  /usr/lib/jvm/java-8-openjdk-amd64/jre/../lib/tools.jar
Please ensure you are using JDK 1.4 or above and
not a JRE (the com.sun.tools.javac.Main class is required).
In most cases you can change the location of your Java
installation by setting the JAVA_HOME environment variable.

	at org.apache.maven.plugin.AbstractCompilerMojo.execute(AbstractCompilerMojo.java:656)
	at org.apache.maven.plugin.CompilerMojo.execute(CompilerMojo.java:128)
	at org.apache.maven.plugin.DefaultBuildPluginManager.executeMojo(DefaultBuildPluginManager.java:101)
	at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:209)
	... 19 more
[ERROR]
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoFailureException
```

javacが見つからず...
mavenのバージョン最新じゃないの関係あるか?
時間かかりそうなのでとりあえず保留

