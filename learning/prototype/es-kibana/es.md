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
[29] pry(main)> q.more_like_this.results.map{|x| { question: x.question, score: x._score }}
=> [{:question=>"オフィスはどこにある？", :score=>4.274851},
 {:question=>"会社はどこにある？", :score=>1.8626721},
 {:question=>"どこから問い合わせすればいい？", :score=>1.4880419}]
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
    && cd elasticsearch-vector-scoring
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

### プラグイン試す
- https://github.com/sdauletau/elasticsearch-position-similarity

gradleの4.0をインストールしたが、2.13じゃないとだめっぽい

```
$ git clone git@github.com:sdauletau/elasticsearch-position-similarity.git
$ cd elasticsearch-position-similarity
$ wget https://services.gradle.org/distributions/gradle-2.13-bin.zip
$ unzip gradle-2.13-bin.zip
$ gradle-2.13/bin/gradle clean assemble
=======================================
Elasticsearch Build Hamster says Hello!
=======================================
  Gradle Version        : 2.13
  OS Info               : Linux 4.9.27-moby (amd64)
  JDK Version           : Oracle Corporation 1.8.0_121 [OpenJDK 64-Bit Server VM 25.121-b13]
  JAVA_HOME             : /usr/lib/jvm/java-8-openjdk-amd64
Incremental java compilation is an incubating feature.

FAILURE: Build failed with an exception.

* What went wrong:
A problem occurred configuring root project 'elasticsearch-position-similarity-master'.
> jps executable not found; ensure that you're running Gradle with the JDK rather than the JRE

* Try:
Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output.

BUILD FAILED

Total time: 33.819 secs
root@2b57e0b09659:/tmp/elasticsearch-position-similarity-master# gradle-2.13/bin/gradle clean assemble --stacktrace
=======================================
Elasticsearch Build Hamster says Hello!
=======================================
  Gradle Version        : 2.13
  OS Info               : Linux 4.9.27-moby (amd64)
  JDK Version           : Oracle Corporation 1.8.0_121 [OpenJDK 64-Bit Server VM 25.121-b13]
  JAVA_HOME             : /usr/lib/jvm/java-8-openjdk-amd64
Incremental java compilation is an incubating feature.

FAILURE: Build failed with an exception.

* What went wrong:
A problem occurred configuring root project 'elasticsearch-position-similarity-master'.
> jps executable not found; ensure that you're running Gradle with the JDK rather than the JRE

* Try:
Run with --info or --debug option to get more log output.

* Exception is:
org.gradle.api.ProjectConfigurationException: A problem occurred configuring root project 'elasticsearch-position-similarity-master'.
	at org.gradle.configuration.project.LifecycleProjectEvaluator.addConfigurationFailure(LifecycleProjectEvaluator.java:79)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.notifyAfterEvaluate(LifecycleProjectEvaluator.java:74)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.evaluate(LifecycleProjectEvaluator.java:61)
	at org.gradle.api.internal.project.AbstractProject.evaluate(AbstractProject.java:529)
	at org.gradle.api.internal.project.AbstractProject.evaluate(AbstractProject.java:90)
	at org.gradle.execution.TaskPathProjectEvaluator.configureHierarchy(TaskPathProjectEvaluator.java:42)
	at org.gradle.configuration.DefaultBuildConfigurer.configure(DefaultBuildConfigurer.java:35)
	at org.gradle.initialization.DefaultGradleLauncher$2.run(DefaultGradleLauncher.java:125)
	at org.gradle.internal.Factories$1.create(Factories.java:22)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:90)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:52)
	at org.gradle.initialization.DefaultGradleLauncher.doBuildStages(DefaultGradleLauncher.java:122)
	at org.gradle.initialization.DefaultGradleLauncher.access$200(DefaultGradleLauncher.java:32)
	at org.gradle.initialization.DefaultGradleLauncher$1.create(DefaultGradleLauncher.java:99)
	at org.gradle.initialization.DefaultGradleLauncher$1.create(DefaultGradleLauncher.java:93)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:90)
	at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:62)
	at org.gradle.initialization.DefaultGradleLauncher.doBuild(DefaultGradleLauncher.java:93)
	at org.gradle.initialization.DefaultGradleLauncher.run(DefaultGradleLauncher.java:82)
	at org.gradle.launcher.exec.InProcessBuildActionExecuter$DefaultBuildController.run(InProcessBuildActionExecuter.java:94)
	at org.gradle.tooling.internal.provider.ExecuteBuildActionRunner.run(ExecuteBuildActionRunner.java:28)
	at org.gradle.launcher.exec.ChainingBuildActionRunner.run(ChainingBuildActionRunner.java:35)
	at org.gradle.launcher.exec.InProcessBuildActionExecuter.execute(InProcessBuildActionExecuter.java:43)
	at org.gradle.launcher.exec.InProcessBuildActionExecuter.execute(InProcessBuildActionExecuter.java:28)
	at org.gradle.launcher.exec.ContinuousBuildActionExecuter.execute(ContinuousBuildActionExecuter.java:81)
	at org.gradle.launcher.exec.ContinuousBuildActionExecuter.execute(ContinuousBuildActionExecuter.java:46)
	at org.gradle.launcher.exec.DaemonUsageSuggestingBuildActionExecuter.execute(DaemonUsageSuggestingBuildActionExecuter.java:51)
	at org.gradle.launcher.exec.DaemonUsageSuggestingBuildActionExecuter.execute(DaemonUsageSuggestingBuildActionExecuter.java:28)
	at org.gradle.launcher.cli.RunBuildAction.run(RunBuildAction.java:43)
	at org.gradle.internal.Actions$RunnableActionAdapter.execute(Actions.java:173)
	at org.gradle.launcher.cli.CommandLineActionFactory$ParseAndBuildAction.execute(CommandLineActionFactory.java:241)
	at org.gradle.launcher.cli.CommandLineActionFactory$ParseAndBuildAction.execute(CommandLineActionFactory.java:214)
	at org.gradle.launcher.cli.JavaRuntimeValidationAction.execute(JavaRuntimeValidationAction.java:35)
	at org.gradle.launcher.cli.JavaRuntimeValidationAction.execute(JavaRuntimeValidationAction.java:24)
	at org.gradle.launcher.cli.CommandLineActionFactory$WithLogging.execute(CommandLineActionFactory.java:207)
	at org.gradle.launcher.cli.CommandLineActionFactory$WithLogging.execute(CommandLineActionFactory.java:169)
	at org.gradle.launcher.cli.ExceptionReportingAction.execute(ExceptionReportingAction.java:33)
	at org.gradle.launcher.cli.ExceptionReportingAction.execute(ExceptionReportingAction.java:22)
	at org.gradle.launcher.Main.doAction(Main.java:33)
	at org.gradle.launcher.bootstrap.EntryPoint.run(EntryPoint.java:45)
	at org.gradle.launcher.bootstrap.ProcessBootstrap.runNoExit(ProcessBootstrap.java:55)
	at org.gradle.launcher.bootstrap.ProcessBootstrap.run(ProcessBootstrap.java:36)
	at org.gradle.launcher.GradleMain.main(GradleMain.java:23)
Caused by: org.gradle.api.GradleException: jps executable not found; ensure that you're running Gradle with the JDK rather than the JRE
	at org.elasticsearch.gradle.test.ClusterFormationTasks$_configureCheckPreviousTask_closure25.doCall(ClusterFormationTasks.groovy:601)
	at org.gradle.api.internal.ClosureBackedAction.execute(ClosureBackedAction.java:67)
	at org.gradle.util.ConfigureUtil.configure(ConfigureUtil.java:130)
	at org.gradle.util.ConfigureUtil.configure(ConfigureUtil.java:110)
	at org.gradle.api.internal.AbstractTask.configure(AbstractTask.java:488)
	at org.gradle.api.internal.tasks.DefaultTaskContainer.create(DefaultTaskContainer.java:93)
	at org.gradle.api.tasks.TaskContainer$create$4.call(Unknown Source)
	at org.elasticsearch.gradle.test.ClusterFormationTasks.configureCheckPreviousTask(ClusterFormationTasks.groovy:590)
	at org.elasticsearch.gradle.test.ClusterFormationTasks$configureCheckPreviousTask$3.callStatic(Unknown Source)
	at org.elasticsearch.gradle.test.ClusterFormationTasks.configureNode(ClusterFormationTasks.groovy:160)
	at org.elasticsearch.gradle.test.ClusterFormationTasks$configureNode$1.callStatic(Unknown Source)
	at org.elasticsearch.gradle.test.ClusterFormationTasks.setup(ClusterFormationTasks.groovy:106)
	at org.elasticsearch.gradle.test.ClusterFormationTasks$setup.call(Unknown Source)
	at org.elasticsearch.gradle.test.RunTask$_closure1.doCall(RunTask.groovy:21)
	at org.gradle.listener.ClosureBackedMethodInvocationDispatch.dispatch(ClosureBackedMethodInvocationDispatch.java:40)
	at org.gradle.listener.ClosureBackedMethodInvocationDispatch.dispatch(ClosureBackedMethodInvocationDispatch.java:25)
	at org.gradle.internal.event.AbstractBroadcastDispatch.dispatch(AbstractBroadcastDispatch.java:44)
	at org.gradle.internal.event.BroadcastDispatch.dispatch(BroadcastDispatch.java:79)
	at org.gradle.internal.event.BroadcastDispatch.dispatch(BroadcastDispatch.java:30)
	at org.gradle.messaging.dispatch.ProxyDispatchAdapter$DispatchingInvocationHandler.invoke(ProxyDispatchAdapter.java:93)
	at com.sun.proxy.$Proxy11.afterEvaluate(Unknown Source)
	at org.gradle.configuration.project.LifecycleProjectEvaluator.notifyAfterEvaluate(LifecycleProjectEvaluator.java:67)
	... 41 more


BUILD FAILED

Total time: 13.082 secs
```

こちらもエラーになる。
