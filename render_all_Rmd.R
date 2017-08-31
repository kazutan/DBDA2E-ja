# まとめてサイトをレンダリングするためのスクリプト
# あくまでこのサイト用で，他でも使えるような汎用的なのは考えていません。


# package読み込み --------
library(rmarkdown)


# パラメータ指定 --------
# renderさせたいサブディレクトリへの相対パスをベクトルで
render_dir <- c("JPA2017")

# site rendering ----
# まずはルートディレクトリ
render_site(input = ".", envir = new.env())

# renderしたいサブディレクトリを一気にrender_site
# ちゃんとそのサブディレクトリに_site.ymlが存在することが前提です

for (i in 1:length(render_dir)) {
  render_site(input = render_dir[i], envir = new.env())
}

# 多分，今のところこれでOKなはず。
# サブディレクトリが込み入ってくると多少手を加えることになるかも。
# その時はその時対応します。
