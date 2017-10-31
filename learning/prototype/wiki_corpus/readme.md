# ※ このフォルダ配下の調査は試行錯誤をまとめていない状態のものが多く残っています。


wikiコーパスのダウンロード

```
$ curl https://dumps.wikimedia.org/jawiki/latest/jawiki-latest-pages-articles.xml.bz2 -o jawiki-latest-pages-articles.xml.bz2
```

xml形式なので、テキストを抜き出す。
そういったプログラムを用意してくださっているので利用する。

```
$ git clone https://github.com/attardi/wikiextractor
```

実行

```
$ python wikiextractor/WikiExtractor.py jawiki-latest-pages-articles.xml.bz2
```

抽出された内容はフォルダに分けられるので、catで1つのファイルにまとめる

```
$ cat text/*/* > jawiki_org.txt
```

内容に<documetn ...>とあったり、空白行があったりするのでトリミング

+ 句点を含まない行を削除する

```
$ echo 'question' > ./jawiki.txt
$ grep '。' ./jawiki_org.txt >> ./jawiki.txt
```

source: http://cantabilemusica.blogspot.jp/2017/01/wiki.html


> テキスト抽出の際には、「文」をコーパスデータの主要な単位とし、記事タイトルや項目の見出しを除いて、１個以上の句点（。）を持った行のみを有効な言語データとする。11 句点を持たない（すなわち文を含まない）行はテキスト抽出から除外する。もちろん、これによりテキストの取りこぼしが生じる可能性は否定できない。しかし、句点を持たない文字列を抽出対象にすることによって増えるノイズデータの量を考えたならば、現実的で妥当な方法であると言える。


source: https://www.google.co.jp/url?sa=t&rct=j&q=&esrc=s&source=web&cd=5&ved=0ahUKEwij7IfV2I3WAhXFTbwKHQ2yDIYQFghEMAQ&url=https%3A%2F%2Fdoors.doshisha.ac.jp%2Fduar%2Frepository%2Fir%2F13068%2F006009020008.pdf&usg=AFQjCNEFV1c7rZ9wRfqZEX8Q3e6nmk1hcw

