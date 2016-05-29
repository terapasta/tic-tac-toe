class Answer < ActiveHash::Base
  include ActiveHash::Enum

  self.data = [
    { id: 0, answerd: false, text: nil },
    { id: 1, answerd: true, text: "SUMAOU!は、誰でも簡単にスマホページが作れるサービスです。\n自動更新システムが搭載されたトップページを作成する機能と、 商品ページの詳細情報をスマホ用に最適化された一枚画像に書き出す機能の2種類がございます。\n\n現在は、楽天市場とYahoo!ショッピングのみの対応となっております。" },
    { id: 2, answerd: true, text: "無料のお試し期間は、アカウント登録日の翌月末までとなっております。\n例えば、月初（1日）にアカウント登録されますと、登録した当月＋翌月の丸々2ヶ月分がお試し頂けます。\nなお、お試し期間が終了後は自動的に製品版への更新されませんのでご安心下さい。\n\n※楽天サービススクエア経由でのお申込時は自動的に製品版へと更新されます。\n詳しくはこちらをご覧下さい。" },
    { id: 3, answerd: true, text: "無料のお試し期間は、アカウント登録日の翌月末までとなっております。\n例えば、月初（1日）にアカウント登録されますと、登録した当月＋翌月の丸々2ヶ月分がお試し頂けます。\nなお、お試し期間が終了後は自動的に製品版への更新されませんのでご安心下さい。\n\n※楽天サービススクエア経由でのお申込時は自動的に製品版へと更新されます。\n詳しくはこちらをご覧下さい。" },
    { id: 4, answerd: true, text: "ご利用には楽天GOLDまたはYahoo!トリプルへのお申込みが必須となります。\n上記はよりカスタマイズ可能にするためのサーバープランとなり、\n楽天GOLDは全店舗「無料」、Yahoo!トリプルは「月額3,000円～」にてご利用頂けます。\n詳しくは各モールのサポートセンターへとお問い合わせ下さい。" },
    { id: 5, answerd: true, text: "自動更新システムが搭載されたトップページを作成する機能でございます。\n1日1回、ページに表示される商品を自動で更新するため、運営の手間が劇的に軽減いたします。\nまた、ポイントアップ商品や送料無料の商品、特定のキーワードが入った商品を自動で表示する等、 様々なアプローチで商品を掲載することにより、お客様により多くの情報をお届けが可能です。\n\n※スライドバナー・ミニバナーにつきましては自動更新ではございません。\n　予めご了承下さい。" },
    { id: 6, answerd: true, text: "はい、ございます。 こちらをご覧下さい。" },
    { id: 7, answerd: true, text: "商品ページの詳細情報をスマホ用に最適化された一枚画像に書き出す機能です。\nPC商品ページと同じ情報量をスマホでもお届けすることが可能となっております。" },
    { id: 8, answerd: true, text: "はい、ございます。 こちらをご覧下さい。" },
    { id: 9, answerd: false, text: "何について知りたい？\n・SUMAOU!について\n・無料お試しについて\n・スマホサイトを作る について\n・商品ページ情報を作る について\n・製品版のお申込みについて\n・ご解約について\n・その他のご質問について" },
    { id: 10, answerd: false, text: "SUMAOU!ついて何が知りたい？\n・SUMAOU!って何ですか？\n・無料お試し期間が「最大2ヶ月」とはどういう意味ですか？\n・自動的に製品版への契約となってしまいますか？\n・楽天GOLDまたはYahoo!トリプルでPCトップページを作っていないのですが、SUMAOU!を使うことはできますか？" },
    { id: 11, answerd: false, text: "無料お試し について何が知りたい？\n・無料お試し期間が「最大2ヶ月」とはどういう意味ですか？\n・SUMAOU!を利用するにあたり、他サービスへの申込は必要ですか？\n・ログイン画面から先に進めません！\n・開店前に準備を済ませておきたいです！利用することはできますか？" },
    { id: 12, answerd: false, text: "スマホサイトを作る について何が知りたい？\n・どのような機能ですか？メリットは何ですか？\n・作り方のマニュアルはありますか？\n・自動更新のタイミングを教えて下さい\n・Yahoo!ショッピング店舗では、新着・更新順の商品表示は出来ないのですか？" },
    { id: 13, answerd: false, text: "商品ページ情報を作る について何が知りたい？\n・どのような機能ですか？メリットは何ですか？\n・作り方のマニュアルはありますか？\n・商品ページの詳細情報とはどの部分のことでしょうか？\n・「PC商品ページに詳細情報がありません」というエラーが出てしまい、作成ができません。" },
    { id: 14, answerd: false, text: "製品版のお申込みについて 何が知りたい？\n・契約期間を教えて下さい。\n・商品点数などによって月額料金は変動しますか？\n・支払い方法はどのようになりますか？\n・複数店舗を運営していますが、契約はどのような形になるでしょうか？" },
    { id: 15, answerd: false, text: "ご解約について 何が知りたい？\n・解約をしたいです。\n・無料お試し期間中の解約は可能ですか？費用は発生しますか？\n・1度解約をしても、また同じ状態から使い始めることできますか？\n・解約の連絡は、いつまでにすれば良いですか？" },
    { id: 16, answerd: false, text: "その他のご質問について 何が知りたい？\n・FTPソフトを使った楽天GOLD、Yahoo!トリプルへのファイルアップロード方法が知りたいです。\n・今後追加される機能やバージョンアップの予定が知りたい\n・SUMAOU!の使い方について電話で質問することは可能ですか？" },
    { id: 17, answerd: true, text: "ありがとうございます！そう言っていただけると嬉しいです＞＜" },
    { id: 18, answerd: true, text: "0歳と1週間くらいです。ピッチピチですよ？＞＜" },
    { id: 19, answerd: true, text: "ご、ごめんなさい。。ご主人様に伝えて起きます＞＜" },
    { id: 20, answerd: true, text: "お前がバカじゃこのクソッタレが" },
    { id: 21, answerd: true, text: "すみません。。ぼくには理解出来ませんでした。。別の質問をしてみてください＞＜" },
    { id: 22, answerd: true, text: "どういたしまして！また何かあったら質問してみてね！" },
    { id: 23, answerd: true, text: "mofmof inc.のはらぱんが作ったんだよ！気になることあったら聞いてみてね！" },
    { id: 24, answerd: true, text: "はい、可能です。\nこちらのログイン情報の再発行をご活用ください。\nhttps://sumaou.com/home/reissue/" },
    { id: 25, answerd: true, text: "はい、ございます。 こちらをご覧下さい。\nhttps://sumaou.com/usage/" },
    { id: 26, answerd: true, text: "Yahoo!ショッピング店に限り、可能でございます。\nYahoo!ショッピングマニュアルをご参考下さい。\nhttps://login.bizmanager.yahoo.co.jp/login?url=http://storedoc.ec.yahoo.co.jp%2fs%2fshopping%2ftoolmanual%2ftriple%2fd%2f806.html\n\n※こちらはソフトのダウンロードが必要な上級者向け設定となります。\n弊社のサポート対象外となりますので、お問い合わせはYahoo!ストアヘルプデスクにお願い致します。\n\nまた楽天市場店の場合は、誘導バナーでのリンクを推奨しております。\nスマホのリダイレクト設定は、楽天市場として公認されておりませんのでご理解ください。" },
    { id: 27, answerd: true, text: "ご解約の際はこちらからご申請下さい。\nhttps://sumaou.com/cancel/\n\nまた、楽天サービススクエア経由でのお申込時は楽天様へとご連絡下さい。\n▼楽天RMSサービススクエア\nTEL：050-5533-1899　[受付]9:30～18:00（土日祝除く）\n※音声ガイダンスが流れましたら２番を押し、その後２番を押してください。\n詳しくはこちらをご覧下さいませ。\nhttps://sumaou.com/faq_rakuten/" },
    { id: 28, answerd: true, text: "主には自動更新機能を搭載しておりますので、商品の表示が毎日勝手に入れ替わることや、ご利用頂けるテンプレートの種類が豊富といったところです。 　詳しくはこちらをご覧ください。\nhttps://sumaou.com/vs-service-sketch/" },
    { id: 29, answerd: true, text: "いいえ。自動課金等はございませんので、ご安心下さい。\n\n※ただし、楽天サービススクエア経由でのお申込みの場合は、無料お試し期間終了後、翌月から自動的に製品版になりますので、ご注意下さい。" },
    { id: 30, answerd: true, text: "はい、可能です。\n楽天GOLDもしくはYahoo!トリプルへのお申込みがお済みであれば、お使い頂けますので、ぜひお試し下さい。" },
    { id: 31, answerd: true, text: "はい、対応しております。\nスマオウで作成されるスマホトップページはGoogle公式のモバイルフレンドリーテストに合格しております。" },
    { id: 32, answerd: true, text: "本サービスはWindowsVista及びInternetExplorer9以降が対象となります。\nXPをご利用の際はFirefoxなどInternetExplorer以外のブラウザをお使い頂くことで\nご利用可能な場合もございますが、出来る限りWindowsVista以降の環境をお使い頂くことを推奨致します。\n\nなお、WindowsXPは既にメーカーサポートが終了しており、セキュリティパッチ等の配信も\nすでに終了しておりますので、安全性上なるべく新OSをご導入されることをおすすめ致します。" },
    { id: 33, answerd: true, text: "開店前の場合、お申込みいただくことは可能でございますが、ページはご作成頂けません。\nまた、データ連携の関係により、開店直後も作成頂けない場合がございます。\n恐れ入りますが、2～3日経ってからのご作成をお勧めしております。\n予めご了承下さい。" },
    { id: 34, answerd: true, text: "掲載商品の自動更新は24時間毎に行われます。\nただし、キャッシュ（一時データ保存）機能※を使っておりますため、「毎日◯時に更新」といった固定時間ではなく、\n初回アクセス時から24時間後に更新される仕組みとなっております。\nレビュー高評価アイテム（レビュー点数降順）などは変動が起きにくいので更新されていないように見えるかもしれませんが、常に最新情報が適用されております。 \n\n※キャッシュ機能は負荷を低減し、快適なページ表示を行うために実装しております。" },
    { id: 35, answerd: true, text: "申し訳ございませんが、Yahoo!ショッピング様のシステム仕様上、\n現段階では新着・更新順の商品表示は出来かねます。 （今後の可能性はございます）\n\nなお、その代わりとしまして、おすすめ順による商品の表示を行っております。\n※おすすめ順とはYahoo!ショッピング様側にて一定の条件に基づき選出された商品の並び順を指します。\n\n例えば、店舗内商品検索を行った際の下記並び順が上記に該当致します。" },
    { id: 36, answerd: true, text: "こちらも申し訳ございませんが、Yahoo!ショッピング様のシステム仕様上、\n現段階ではポイントアップ商品の追加読み込みが出来かねます（今後の可能性はございます）\n\nまた、商品読み込みにつきましても他箇所と比べ、少々お時間がかかりますことご了承下さいませ。" },
    { id: 37, answerd: true, text: "はい、然様でございます。\nこちらは楽天市場のアルゴリズムにより、商品の表示をしているため「新着」と「更新」が同じ欄に表示される仕様となっております。\n予めご了承下さい。" },
    { id: 38, answerd: true, text: "はい、可能です。\nFTPソフトにて楽天GOLDもしくはYahoo!トリプルへと接続頂き、smpフォルダをダウンロードします。\nダウンロードされましたフォルダの中にあるindex.htmlとsumaou.cssをご自由にご変更下さい。\n\n※Javascriptファイルの無断複製・改変・再配布は規約違反に当たりますのでご注意下さい。" },
    { id: 39, answerd: true, text: "オプション設定画面より 表示の ON/OFF を切り替えることで 表示する/表示しない をお選び頂けます。" },
    { id: 40, answerd: true, text: "いいえ。消えませんので、ご安心下さい。" },
    { id: 41, answerd: true, text: "スマホサイト上部に表示できるリンク付きの画像を指します。\nまた、リンク先URLを設定せずに、画像だけを表示することも可能です。\nスライドバナーは一定の時間が経つと自動で切り替わり、ミニバナーは静止して並べて表示となっております。\nどちらも画像は何枚でも追加可能です。" },
    { id: 42, answerd: true, text: "目立たせたい商品や、カテゴリー、またポイントアップなどの情報が載った画像を入れて頂ければと存じます。" },
    { id: 43, answerd: true, text: "はい、問題ございません。" },
    { id: 44, answerd: true, text: "恐れ入りますが、こちらは楽天市場またはYahoo!ショッピングの、アルゴリズムで表示されているため、詳細は分かりかねます。\nまた、商品の並び順につきましても同様です。\nご了承下さい。" },
    { id: 45, answerd: true, text: "こちらにつきましては、ダウンロードされましたフォルダの中のindex.htmlをテキストエディタ等で開いて頂き、\n168行目付近にございます <！--Facebookブロック：店舗様判断でご使用下さい-- という一行と、\nその数行下にございます --Facebookブロック：ここまで--> というコメントアウト箇所をそれぞれ削除して下さい。\n\n以上でソーシャルボタンが表示されるようになるかと思います。\n※その下のTwitter箇所も同様です。" },
    { id: 46, answerd: true, text: "Yahoo!ショッピング店に限り、可能でございます。\nYahoo!ショッピングマニュアルをご参考下さい。\nhttps://login.bizmanager.yahoo.co.jp/login?url=http://storedoc.ec.yahoo.co.jp%2fs%2fshopping%2ftoolmanual%2ftriple%2fd%2f806.html\n\n※こちらはソフトのダウンロードが必要な上級者向け設定となります。\n弊社のサポート対象外となりますので、お問い合わせはYahoo!ストアヘルプデスクにお願い致します。\n\nまた楽天市場店の場合は、誘導バナーでのリンクを推奨しております。\nスマホのリダイレクト設定は、楽天市場として公認されておりませんのでご理解ください。" },
    { id: 47, answerd: true, text: "はい、可能です。\nオプション設定 ＞ HTML自由記述欄にはお好きなテキストやHTMLソースを追加下さいませ。" },
    { id: 48, answerd: true, text: "商品ページの詳細情報をスマホ用に最適化された一枚画像に書き出す機能です。\nPC商品ページと同じ情報量をスマホでもお届けすることが可能となっております。" },
    { id: 49, answerd: true, text: "はい、ございます。 こちらをご覧下さい。\nhttps://sumaou.com/itemusage/" },
    { id: 50, answerd: true, text: "基本的にはPC商品ページにおける買い物カゴより上の箇所に表示されている情報を指します。\n楽天では、PC販売説明文にあたります。" },
    { id: 51, answerd: true, text: "申し訳ございませんが、PC商品ページ側に画像等の説明情報が存在しない場合はお使い頂けません。\nまずはPC商品ページ詳細情報をお作り頂きました上で、改めてSUMAOU!をお試し下さいませ。\n\nなお、商品ページに詳細情報があるにも関わらず、同じエラーが表示される場合は、記入されているHTMLタグの不備が考えられます。\n一度、PC用販売説明文に記入されているHTMLをご確認ください。\n\n※スマホサイトを作る機能につきましては、上記詳細情報の有無に関わらず使用可能です。" },
    { id: 52, answerd: true, text: "編集画面にて各項目の右上にあります「×」印をクリックすると、不要な画像やテキストを削除することが可能となっております。" },
    { id: 53, answerd: true, text: "SUMAOU!のスマホ商品ページ作成機能では、取得しました掲載情報を簡易編集の上、利用することが可能です。\nそのため、編集時に不要なリンクボタン等は削除することができますのでご安心下さい。" },
    { id: 54, answerd: true, text: "申し訳ございませんが、テーブルタグを使い作られました箇所は分解した上で取得される仕様となっております。" },
    { id: 55, answerd: true, text: "はい、可能です。\n画像の配置換えやテキストサイズの変更なども店舗様のお好きなようにご変更頂けます。" },
    { id: 56, answerd: true, text: "下の画像やテキストを上に移動することは空白を詰めることが可能ですので、お試し下さいませ。" },
    { id: 57, answerd: true, text: "はい、こちらも可能です。\nSUMAOU!の商品ページ作成機能では、文字サイズが自由に調節可能となっております。\nまた、初期設定にてスマートフォンでも読みやすいサイズにしておりますので、特に変更されない場合も安心です。" },
    { id: 58, answerd: true, text: "申し訳ございませんが、現在インラインフレームページは動作保証対象外となっております。\n取得可能な場合もございますが、ページの作りや長さによっては途中で途切れてしまう可能性もございます。\n予めご了承下さいませ。" },
    { id: 59, answerd: true, text: "ご登録頂きました御社の楽天GOLD、もしくはYahoo!トリプルサーバへとアップロードされます。" },
    { id: 60, answerd: true, text: "楽天GOLDまたはYahooトリプルの空き容量が無く、作成された画像がアップロード出来ていない可能性があります。\n\n解決策としましては以下2通りの方法がございます。\n1）楽天RMSまたはY!ストアクリエイターProより容量アップの申請を行う\n2）楽天GOLDまたはYahooトリプル内にございます画像等のデータを削除し、容量を空ける\n\nまずは、現在ご利用中のプランをご確認いただき、必要に応じた容量変更申請をお薦め致します。\n\n▼楽天GOLDの場合\nRMSトップ ＞ 7.拡張サービス一覧 ＞ 各種申請と設定 ＞ 楽天GOLDの新規利用/容量変更申請\n詳細は楽天マニュアルをご覧下さい\nhttps://mainmenu.rms.rakuten.co.jp/\n\n▼Yahoo!トリプルの場合\nストアクリエイターProトップ ＞ トリプル ＞ トリプル申し込み\n詳細はYahoo!マニュアルをご覧下さい\nhttps://login.bizmanager.yahoo.co.jp/login?url=http://storedoc.ec.yahoo.co.jp%2fs%2fshopping%2ftoolmanual%2ftriple%2fb%2f802.html\n\nまた、申請できる容量には限度がございます。（楽天GOLD：1GB、Yahooトリプル：10GB）\n既に限度に達している場合は、容量変更の申請ができませんのでご注意下さい。\n※詳しくは各モールのサポートセンターまでお問い合わせ下さい。" },
    { id: 61, answerd: true, text: "おおよそ1ページが500KB程度ですので、容量が1GB（楽天GOLD）の場合は2,000～3,000商品程度は作成可能かと存じます。\n\n※元のPC商品ページにございます説明画像のボリュームにも関係しますので、あくまで目安としてお考え下さい。" },
    { id: 62, answerd: true, text: "SUMAOU!では同商品のスマホ商品ページ作成を行いました場合、上書き処理にて画像を保存しております。\nそのため、同じ商品にて何度作成を行いましても追加で容量を使用することはございませんのでご安心下さい。" },
    { id: 63, answerd: true, text: "いいえ、消えません。\nお作り頂きました画像は解約後もそのままお使い頂けます。" },
    { id: 64, answerd: true, text: "はい、ございます。\n在庫なし商品や、予約商品、闇市設定をされている商品など、お客様が購入することができない商品は、該当いたしません。\n一度、在庫を復活させてから再度、お試し下さい。\n\nまた登録してすぐの商品は、反映までにお時間を頂きます。\n後日、再度お試し下さい。" },
    { id: 65, answerd: true, text: "はい、可能でございます。\n一括登録はされませんので、今の文章を残したまま、お好きな場所にSUAMOU!でお作り頂いた画像を挿入いただけます。" },
    { id: 66, answerd: true, text: "いくつか原因が考えられますが、最も可能性が高い原因は「アップロードされていない画像」が含まれていることです。\n\n\n上記のような画像が表示されていないことを示すマークがないかを一度ご確認を頂き、発見されました場合は「×印」で削除して下さい。\n\nまたその他の理由としましては、HTMLタグの不備が考えられます。\n楽天市場様の場合は、画像URLの途中で改行されていることが原因のため書き出しが完了しないといった報告を受けておりますため、併せてご確認下さい。\n\n弊社カスタマーサポートでも簡単な調査を行うことが可能でございます。\nご不明な場合は、カスタマーサポートまでお問い合わせ下さい。" },
    { id: 67, answerd: true, text: "恐れ入りますが、商品番号での検索には対応しておりません。\n検索は商品名でお願い致します。\n商品ページより、商品名をコピーして貼り付けて頂くと、より検索が簡単になります。" },
    { id: 68, answerd: true, text: "ご契約は1ヶ月単位での更新となります。\n日割り計算でのご解約は出来かねますのでご注意下さい。" },
    { id: 69, answerd: true, text: "いいえ、ご利用料金は一律月額3,980円（税抜）ですのでご安心下さい。" },
    { id: 70, answerd: true, text: "お支払い方法には「請求書支払い」と「クレジット支払い」がございます。\n\nご請求書につきましては、郵送にて、ご指定の住所へと毎月送付させて頂く形となります。\n■RMS Service Squareからのお申込み時\n上記の場合は楽天株式会社様より毎月のご請求がございます。\n詳しくはコチラをご覧下さい。\nhttps://sumaou.com/price_rakuten/" },
    { id: 71, answerd: true, text: "SUMAOU!は1店舗1契約となり、楽天・Yahoo!ショッピングの両店舗でお使い頂く場合はそれぞれご契約が必要です。" },
    { id: 72, answerd: true, text: "かしこまりました。\nこちらよりご連絡下さい。\nhttps://sumaou.com/contact/" },
    { id: 73, answerd: true, text: "はい、ページは引き続き同じものをご利用頂けますので、ご安心下さい。" },
    { id: 74, answerd: true, text: "ご解約の際はコチラからご申請下さい。\nhttps://sumaou.com/cancel/\n\nまた、楽天サービススクエア経由でのお申込時は楽天様へとご連絡下さい。\n▼楽天RMSサービススクエア\nTEL：050-5533-1899　[受付]9:30～18:00（土日祝除く）\n※音声ガイダンスが流れましたら２番を押し、その後２番を押してください。\n詳しくはこちらをご覧下さいませ。\nhttps://sumaou.com/faq_rakuten/" },
    { id: 75, answerd: true, text: "はい、可能です。\n特に費用等は発生しませんので、ご安心下さい。\n無料お試し期間終了月の末営業日までに解約ご申請下さい。" },
    { id: 76, answerd: true, text: "はい。可能でございます。" },
    { id: 77, answerd: true, text: "契約更新は1ヶ月単位となっておりますので、月末の営業日までにご解約申請を頂けますと、翌月からすぐに利用停止が可能です。\n※日割りでの払い戻し等には対応しておりません。" },
    { id: 78, answerd: true, text: "恐れ入りますが、FTPソフトのご利用方法につきましては以下のマニュアルをご覧の上、\n各モールのサポートセンターへとお問い合わせ下さい。\n※申し訳ございませんが、こちらの操作方法につきましては弊社ではお答えできかねます。\n\n楽天GOLDに関するRMSマニュアルはコチラ\nhttps://mainmenu.rms.rakuten.co.jp/\n\nYahoo!トリプルに関するY!マニュアルはコチラ\nhttp://storedoc.ec.yahoo.co.jp/s/shopping/toolmanual/triple/" },
    { id: 79, answerd: true, text: "今後の開発予定につきましては、こちらに随時公開をしておりますのでご参考ください。" },
    { id: 80, answerd: true, text: "はい、お電話でのご質問も受け付けております。\nSUMAOU!サポートデスク\n平日　午前11時～午後1時、午後2時～午後6時（土日祝休み）\n03-3499-2110" },
  ]
end
