imap-deleter
============

gmail経由だと、ウイルス添付メールは置き去りにされる。cronで定期的にコレで削除する。


# known bug

JRuby 1.6.7.2 で動かした場合、UTF-8のデコードに失敗し、例外を吐いて終了することがわかってます。


# how to config

config.yml.sampleをコピーしてconfig.ymlを作成し、そこに設定を書きこんで使ってください。
設定が終わったら、ruby imap-deleter.rb で動きます。

```
cp config.yml.sample config.yml
vi config.yml
ruby imap-deleter.rb
```
