# バージョン
- ruby 2.3.0
- rails 5.1.4

# staging環境ログインアカウント
- URL  
https://stage-habfoc.herokuapp.com/

- user1 (user2のパートナー)  
user1@gmail.com  
000000  

- user2 (user1のパートナー)  
user2@gmail.com  
000000  

# アセッツプリコンバイル
`bundle exec rake assets:precompile RAILS_ENV=production`  
herokuの場合はこれをしてデプロイしないとassetsが反映されない。

# staging環境デプロイ方法
1. stage-habfocのgitリポジトリを追加  
`git remote add staging HEROKU-GIT-URL`  
2. stagingブランチにマージ
3. stagingブランチをpush  
`git push staging staging:master`
4. マイグレーション  
`heroku run rails db:migrate --remote staging`  
or  
`heroku run rails db:migrate --app stage-habfoc`

# stylesheet適応方法
デフォルトなら`rails g`コマンドでassetsやhelperが自動生成されるが、  
`application.rb`で自動生成しないようにしてあるため、
scssファイルを足したいなら、`app/assets/stylesheets/`配下にファイルを作成し、  
`app/assets/stylesheets/application.scss`に`@import 'ファイル名';`を追記する。

# RDoc表示方法
ターミナルでコマンド入力  
`yardoc app/helpers/* app/models/*   app/controllers/*`  
`yard server`  
http://localhost:8808/docs/index にアクセス  

# テストデータ挿入方法
1. seedファイルを指定して挿入する方法  
    `rails db:seed_from_file SEED_FILENAME='ファイル名' RAILS_ENV=環境`   
    ファイル名はパス付き。パスはdb/からの相対パス。`db/seeds/sample_seeds.rb`なら`seeds/sample_seeds.rb`  
    e.g  
    `rails db:seed_from_file SEED_FILENAME='seeds/01_dummy_users_seeds.rb' RAILS_ENV=test`  
2. seedsディレクトリ配下の全てのseedを実行  
    `rails db:seeds RAILS_ENV=test`

# AWS使用時設定方法
利用環境:
 - サーバー:AmazonLinux2
 - 参考サイト: 
  - https://qiita.com/yutaka_izumaru/items/44ae64df91f9fed593d2(途中からのRuby導入方法)
  - https://normalblog.net/system/ruby-on-rails5-aws/ (3行ぐらい役に立った)
  - https://qiita.com/yujiro0102/items/0bc30ab0a73de62c4e2d (何故かNode.js入れれなかったので)
手順
 1. sshできる必要設定をAmazonマネジメントコンソールより設定
 2. ssh後以下コマンドを上から実行
 ```text
yum update
##多分ここから
sudo yum install \
git make gcc-c++ patch \
openssl-devel \
libyaml-devel libffi-devel libicu-devel \
libxml2 libxslt libxml2-devel libxslt-devel \
zlib-devel readline-devel \
mysql mysql-server mysql-devel \
ImageMagick ImageMagick-devel \
epel-release
##ここまで入力できる
##node.jsインストール手順
##必要ないかもだけど下2つ実行（怒られても無視で）
sudo yum -y install gcc-c++
sudo yum -y install git
##ここから本番
##nvmのクローン
git clone https://github.com/creationix/nvm.git ~/.nvm
##パスを通す
source ~/.nvm/nvm.sh
vim .bash_profile
## 以下を追加(.bash_profile)
# nvm
if [[ -s ~/.nvm/nvm.sh ]] ; then
        source ~/.nvm/nvm.sh ;
fi
#インストール可能なNode.jsの確認
nvm ls-remote
#最新版(安定版)をインストール
nvm install 8.11.4
#インストールされたバージョンの確認(念の為)
node -v
#nodejs終わり
#以下からRuby
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
sudo yum install gcc openssl-devel readline-devel sqlite-devel
rbenv install 2.3.0
rbenv global 2.3.0
gem update --system
gem install --no-ri --no-rdoc rails
gem install bundler
#sqliteなのか・・・？
gem install sqlite3
#これもわかってない
gem install unicorn
rbenv rehash
rails -v
rails new /var/www/html/sample
sudo mkdir /var/run/unicorn
sudo chmod 777 /var/run/unicorn
sudo chown -R nginx:ec2-user /var/www/html
sudo chmod 2777 /var/www -R
```
上記暫定版のため使用の際は注意
  

# 背景
- カップルの財布を別にしたい
- 出費をしっかり管理したい
- 二人の出費をエクセルなどで管理するのは計算が少し複雑で、たまに例外もあったりすると、入力ミスや計算ミスが多くなる。

# 各機能
### 出費の入力(expense)
出費の入力のときに、自分の出費かパートナーとの出費かを入力するだけで、総支出額やカテゴリ別の出費の計算などを自動計算。  
出費の一覧画面で表示されるもの
- 支出合計額 (設定画面で共有を許可すると、パートナーの分も表示)
  - カテゴリ別の支出合計額 (設定画面で共有を許可すると、パートナーの分も表示)  
  各カテゴリがリンクになっていて、クリックすると、出費リストがそのカテゴリの出費だけのものに入れ替わる。
- カテゴリ別の予算残高 (設定画面で共有を許可すると、パートナーの分も表示)
- 入力した出費の一覧
  - Bothタブ 二人のための出費のリスト
  - Mine 自分のためだけの出費のリスト  
  - (設定画面で共有を許可すると、パートナーの分も表示)  
  Partner パートナーの自分のためだけの出費のリスト
- 前後月移動ボタン  


### 予算 (badget)
予算を登録しておくと、出費一覧画面に「カテゴリ別予算残金」を計算してくれる。  
これは予算を登録したものだけが、カテゴリ登録順に表示されるようになっている。  
予算を登録するときも登録していないものだけが選択できるようになっている。

### 繰り返し出費の計算(repeat_expnese)
毎月決まった出費があるのであれば、これに登録しておけば毎月レコードを追加してくれる。  
開始日と終了日、毎月何日(1~28)を選択できる。  
ただ、DB定義がexpensesとほぼ同じなので見直す必要がある。  
また、更新したときや消去したときの挙動が考慮できていない。

### 手渡し金額(pay)
自分がパートナーのために払った金額を考慮して、先月までの自分が本来払わなければいけない金額を計算する機能。
そして、自分がパートナーに手渡した金額を入力していけば、過去の全ての二人の出費のバランスを計算してくれる。
#### メリット
- 手渡す金額はいくらでもいいので、細かいお金は考えなくていい。
- パートナーのものを立て替えておいたときも、相手の支払い額100%で入力するだけで、その都度支払わなくて済む。
- 過去の出費を修正したり、過去の日付で新しく出費を入力しても、現在相手に手渡さなければいけない金額を計算してくれる。

### 欲しいものリスト(want)
二人に必要なものを登録しておくリスト。  
思いついたときに登録しておくと、買い物のときなどに便利。

### 通知機能(notification)
パートナーが二人のために行ったものは全て通知される。  
この機能がないと、過去の出費の金額を編集すると、手渡し金額が変わってしまうので、誤って編集してしまったときに、    
パートナーも気付かずにやりすごしてしまう。  
これにより、パートナーに通知され、誤入力を防ぐことができる。  
ただ、表記がいまいちわかりにくいし、リンクはよくわからないところに飛んでしまうので、改修が必要。

### 設定画面(setting)
- 自分だけの出費を共有  
    許可すると出費一覧画面にパートナーの合計・カテゴリ残高・自分だけの出費一覧が追加される。  
    → 財布別で徹底的に管理しているのが、他人のようで嫌というのを緩和できるかも。
