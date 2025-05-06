# 開発用Dockerイメージ

このDockerイメージは、複数のプログラミング言語とツールを含む開発環境を提供します。

## 基本情報

- **ベースイメージ**: Ubuntu 24.04
- **タイムゾーン**: UTC
- **ロケール**: en_US.UTF-8
- **デフォルトシェル**: bash

## インストール済みのソフトウェア

### プログラミング言語

| 言語 | バージョン | 備考 |
|------|------------|------|
| Python | 3 (デフォルト), 3.9, 3.10, 3.11 | pipx, setuptools, wheel も含む |
| Node.js | 20.x, 22.x | |
| Java | OpenJDK 8, 11, 17, 21 | デフォルトは Java 17 |
| Rust | 最新版 | rustfmt コンポーネント付き |
| Go | 1.21.13, 1.22.12, 1.23.8 | |
| PHP | 8.3 | Composer も含む |
| .NET | SDK 8.0 | |
| PowerShell | 最新版 | |

### データベース

| データベース | バージョン | 備考 |
|------------|------------|------|
| PostgreSQL | 16 | リモートアクセス対応 |
| MySQL | 最新版 | rootパスワード: root |

### 開発ツール

- **ビルドツール**: gcc, g++, make, autoconf, automake, cmake など
- **バージョン管理**: git, mercurial
- **ユーティリティ**: curl, wget, zip/unzip, ssh, jq, sudo など

## 環境変数

### Java 関連
- `JAVA_HOME_8_X64=/usr/lib/jvm/java-8-openjdk-amd64`
- `JAVA_HOME_11_X64=/usr/lib/jvm/java-11-openjdk-amd64`
- `JAVA_HOME_17_X64=/usr/lib/jvm/java-17-openjdk-amd64`
- `JAVA_HOME_21_X64=/usr/lib/jvm/java-21-openjdk-amd64`
- `JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64` (デフォルト)

## 使用方法

### ビルド方法
```bash
docker build -t dev-environment .
```

### 実行方法
```bash
docker run -it dev-environment
```

## ワークディレクトリ

コンテナ内のデフォルトワークディレクトリは `/workspace` に設定されています。
