FROM centos:centos7

ENV RUBY_VERSION 2.6.3
ENV BUNDLER_VERSION 1.17.3
ENV LANG C.UTF-8
ENV APP_ROOT /usr/src/household_account_book

# timezone
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# 必要パッケージをインストール
RUN yum -y update
RUN yum -y install \
  gcc \
  gcc-c++ \
  make \
  glibc-langpack-ja \
  readline \
  readline-devel \
  tar \
  bzip2 \
  openssl-devel \
  zlib-devel \
  # ここまではrubyに必要なもの
  # ここからはこのプロジェクトのみ必要なもの
  graphviz \
  git \
  curl \
  vim \
  sudo \
# yum -y install gcc gcc-c++ make glibc-langpack-ja readline readline-devel tar bzip2 openssl-devel zlib-devel git curl vim sudo
RUN yum -y install postgresql postgresql-devel

# yarnをインストール
# ↓ https://classic.yarnpkg.com/en/docs/install/#centos-stable
RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
# ↓ https://github.com/nodesource/distributions#installation-instructions-1
RUN curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
RUN yum -y install nodejs yarn
RUN yum clean all

# rbenvとruby-buildインストール
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build

# rbenvを早くするために動的なbash拡張をコンパイルする
RUN /usr/local/rbenv/src/configure
RUN make -C /usr/local/rbenv/src

# rbenvのpathを通す
RUN echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init --no-rehash -)"' >> /etc/profile.d/rbenv.sh
RUN source /etc/profile.d/rbenv.sh
ENV RBENV_ROOT /usr/local/rbenv
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH

# rbenvをセットアップ
#RUN rbenv init
# rbenvの確認
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash

# rubyインストール
RUN rbenv install $RUBY_VERSION
RUN rbenv rehash
RUN rbenv global $RUBY_VERSION

# bundlerをインストール
RUN gem install bundler -v $BUNDLER_VERSION -N

# ログインユーザーを作成
RUN \
 useradd -m hab; \
 echo 'hab:hab' | chpasswd; \
 echo "hab ALL=NOPASSWD: ALL" >> /etc/sudoers
COPY ./.bash_profile /home/hab/
RUN chown -R hab:hab /home/hab

# アプリケーションソースコードのディレクトリを作成
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

# bundle install
COPY Gemfile* $APP_ROOT/
RUN bundle install
RUN rbenv rehash

# npm packagesをインストール
COPY package.json $APP_ROOT
COPY yarn.lock $APP_ROOT
RUN yarn install --frozen-lockfile

# 残りのソースコードを全て配置
COPY ./ $APP_ROOT

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
USER hab

EXPOSE 3000

# サーバー起動
#CMD ["rails", "server", "-b", "0.0.0.0"]