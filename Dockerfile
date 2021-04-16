FROM centos:centos7

ENV RUBY_VERSION 2.6.7
ENV BUNDLER_VERSION 1.17.3
ENV LANG C.UTF-8
ENV APP_ROOT /usr/src/household_account_book
# rbenvのpathを通す
ENV RBENV_ROOT /home/dev/.rbenv
ENV PATH ${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}

# timezone
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# rubyに必要なパッケージをインストール
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
  zlib-devel

# 便利パッケージをインストール
RUN yum -y install \
  git \
  curl \
  vim \
  sudo

# このプロジェクトに必要な他のパッケージをインストール
RUN yum -y install \
  postgresql \
  postgresql-devel \
  graphviz

# yarnとnodejsをインストール
# ↓ 参照: https://classic.yarnpkg.com/en/docs/install/#centos-stable
RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
# ↓ 参照: https://github.com/nodesource/distributions#installation-instructions-1
RUN curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
RUN yum -y install nodejs yarn
RUN yum clean all

# entrypointシェルを設定
COPY script/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# devユーザー作成
RUN \
 useradd -m dev; \
 echo 'dev:dev' | chpasswd; \
 echo "dev ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir -p ${APP_ROOT}
RUN chown -R dev:dev ${APP_ROOT}
USER dev

# rbenvとruby-buildインストール
RUN git clone https://github.com/sstephenson/rbenv.git ${RBENV_ROOT}
RUN git clone https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build

# rbenvを速くするために動的なbash拡張をコンパイルする
RUN ${RBENV_ROOT}/src/configure
RUN make -C ${RBENV_ROOT}/src

# シェルにrbenvを設定
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
RUN rbenv init -

# rbenvの確認
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash

# rubyインストール
RUN rbenv install ${RUBY_VERSION}
RUN rbenv rehash
RUN rbenv global ${RUBY_VERSION}

# bundlerをインストール
RUN gem install bundler -v ${BUNDLER_VERSION} -N

# bundle install
WORKDIR ${APP_ROOT}
COPY --chown=dev:dev Gemfile* ${APP_ROOT}/
RUN bundle install
RUN rbenv rehash

# npm packagesをインストール
COPY --chown=dev:dev package.json ${APP_ROOT}
COPY --chown=dev:dev yarn.lock ${APP_ROOT}
RUN yarn install --frozen-lockfile

EXPOSE 3000

# サーバー起動
#CMD ["rails", "server", "-b", "0.0.0.0"]