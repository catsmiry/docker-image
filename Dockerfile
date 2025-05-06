FROM ubuntu:24.04

# 非対話モードを設定
ENV DEBIAN_FRONTEND=noninteractive

# タイムゾーンを設定
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# システムの更新とベースパッケージのインストール
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    acl \
    aria2 \
    autoconf \
    automake \
    binutils \
    bison \
    brotli \
    bzip2 \
    coreutils \
    curl \
    dbus \
    dnsutils \
    dpkg \
    dpkg-dev \
    fakeroot \
    file \
    findutils \
    flex \
    fonts-noto-color-emoji \
    ftp \
    g++ \
    gcc \
    gnupg2 \
    haveged \
    iproute2 \
    iputils-ping \
    jq \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libyaml-dev \
    locales \
    lz4 \
    m4 \
    make \
    mediainfo \
    mercurial \
    net-tools \
    netcat \
    openssh-client \
    p7zip-full \
    p7zip-rar \
    parallel \
    patchelf \
    pigz \
    pkg-config \
    pollinate \
    python-is-python3 \
    rpm \
    rsync \
    shellcheck \
    sphinxsearch \
    sqlite3 \
    ssh \
    sshpass \
    sudo \
    swig \
    tar \
    telnet \
    texinfo \
    time \
    tk \
    tree \
    tzdata \
    unzip \
    upx \
    wget \
    xvfb \
    xz-utils \
    zip \
    zsync \
    software-properties-common \
    build-essential \
    ca-certificates \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ロケールの設定
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Python のインストール
RUN apt-get update && apt-get install -y python3 python3-pip python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --no-cache-dir pipx \
    && pip3 install --no-cache-dir setuptools wheel

# Node.js のインストール
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@10.8.2 \
    && npm install -g yarn@1.22.22 \
    && npm install -g n \
    && n 20.19.1 \
    && n 18.20.8 \
    && n 22.15.0

# Docker のインストール
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Java のインストール
RUN apt-get update && apt-get install -y openjdk-8-jdk openjdk-11-jdk openjdk-17-jdk openjdk-21-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Java 環境変数の設定
ENV JAVA_HOME_8_X64=/usr/lib/jvm/java-8-openjdk-amd64 \
    JAVA_HOME_11_X64=/usr/lib/jvm/java-11-openjdk-amd64 \
    JAVA_HOME_17_X64=/usr/lib/jvm/java-17-openjdk-amd64 \
    JAVA_HOME_21_X64=/usr/lib/jvm/java-21-openjdk-amd64 \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Rust のインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && . $HOME/.cargo/env \
    && rustup component add rustfmt

# Go のインストール
RUN curl -fsSL https://golang.org/dl/go1.21.13.linux-amd64.tar.gz | tar -C /usr/local -xzf - \
    && curl -fsSL https://golang.org/dl/go1.22.12.linux-amd64.tar.gz | tar -C /usr/local -xzf - \
    && curl -fsSL https://golang.org/dl/go1.23.8.linux-amd64.tar.gz | tar -C /usr/local -xzf -

ENV PATH=$PATH:/usr/local/go/bin

# AWS CLI のインストール
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Azure CLI のインストール
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# GitHub CLI のインストール
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# PostgreSQL のインストール
RUN apt-get update && apt-get install -y postgresql postgresql-contrib \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/16/main/pg_hba.conf \
    && echo "listen_addresses='*'" >> /etc/postgresql/16/main/postgresql.conf

# MySQL のインストール
RUN apt-get update && apt-get install -y mysql-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && echo "mysql-server mysql-server/root_password password root" | debconf-set-selections \
    && echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

# PHP のインストール
RUN apt-get update && apt-get install -y php8.3 php8.3-cli php8.3-common php8.3-curl php8.3-mbstring php8.3-mysql php8.3-xml php8.3-zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# .NET SDKのインストール
RUN apt-get update && apt-get install -y dotnet-sdk-8.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Webサーバーのインストール
RUN apt-get update && apt-get install -y apache2 nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Android SDKのインストール（一部のみ）
RUN mkdir -p /usr/local/lib/android/sdk \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O android-sdk.zip \
    && unzip -q android-sdk.zip -d /usr/local/lib/android/sdk \
    && rm android-sdk.zip

ENV ANDROID_HOME=/usr/local/lib/android/sdk \
    ANDROID_SDK_ROOT=/usr/local/lib/android/sdk \
    PATH=$PATH:$ANDROID_HOME/cmdline-tools/bin:$ANDROID_HOME/platform-tools

# Pythonの追加バージョンをインストール
RUN apt-get update && apt-get install -y \
    python3.9 python3.9-dev python3.9-venv \
    python3.10 python3.10-dev python3.10-venv \
    python3.11 python3.11-dev python3.11-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# PowerShell のインストール
RUN apt-get update && apt-get install -y wget apt-transport-https software-properties-common \
    && wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm packages-microsoft-prod.deb

# クリーンアップ
RUN apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ワークディレクトリを設定
WORKDIR /workspace

# デフォルトのシェルをbashに設定
SHELL ["/bin/bash", "-c"]

# コンテナの実行時にbashを起動
CMD ["/bin/bash"]
