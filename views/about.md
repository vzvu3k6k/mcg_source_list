# MCG Source List

[Markov Chain Generator](http://mcg.herokuapp.com/)のソースをTwitterから収集するサイトです。

- [http://mcg-source-list.herokuapp.com/](http://mcg-source-list.herokuapp.com/)
- [https://github.com/vzvu3k6k/mcg_source_list/](https://github.com/vzvu3k6k/mcg_source_list/)

## インストール

以下の手順を実行すればHerokuで動かせます。

1. [https://apps.twitter.com/](https://apps.twitter.com/)でTwitterのApplicationを登録する。
1. [https://heroku.com/deploy?template=https://github.com/vzvu3k6k/mcg_source_list/tree/master](https://heroku.com/deploy?template=https://github.com/vzvu3k6k/mcg_source_list/tree/master)を開き、先ほど登録したApplicationの各種キーを設定してデプロイする。
1. Schedulerに`bundle exec ruby scripts/crawl.rb`を追加する。

## ライセンス

[Creative Commons — CC0 1.0 Universal](http://creativecommons.org/publicdomain/zero/1.0/)
