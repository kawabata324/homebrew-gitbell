# Homebrew tap for GitBell

このディレクトリの中身が、そのまま Homebrew の tap リポジトリになる。

## 使う側

```bash
brew tap kawabata324/gitbell
brew install --cask gitbell
```

Apple Developer ID による署名がまだ無いので、インストール後に quarantine
属性を外す必要がある（手順は cask の caveats に出る）。

```bash
xattr -dr com.apple.quarantine /Applications/GitBell.app
```

初回ログイン時には macOS の Keychain が許可を求めてくる。「常に許可」を選ぶこと。
ad-hoc 署名はバイナリ内容から決まるので、アップデートのたびに別アプリ扱いになり、
一度だけ再び聞かれる。Developer ID で署名すれば、この繰り返しは無くなる。

## 公開する側

tap は本体とは別のリポジトリで、名前は `homebrew-` で始める決まりになっている。
`kawabata324/homebrew-gitbell` を作り、このディレクトリの中身をルートへ置く。

```bash
gh repo create kawabata324/homebrew-gitbell --public
cp -R packaging/homebrew/. /path/to/homebrew-gitbell/
```

### private のままだと何が起きるか

- **tap リポジトリ**: private でも自分は `brew tap` できる（git clone に SSH 認証が効くため）。
  他の人は clone できないので入れられない。
- **本体リポジトリ**: private だと Release のアセットが認証なしで 404 を返す。
  brew は認証ヘッダを送らないので、`brew install` はダウンロードで失敗する。

つまり **配る目的なら本体リポジトリの public 化が要る**。
手元で試すだけなら、`url` を `file:///path/to/GitBell-X.Y.Z-arm64.dmg` にした
cask を tap に置けば private のままでも動く。

## リリースのたびにやること

1. `pnpm dist` で `release/` に dmg を作る
2. GitHub Release（タグ `vX.Y.Z`）へ両方の dmg を上げる
3. `Casks/gitbell.rb` の `version` と 2 つの `sha256` を更新する

```bash
shasum -a 256 release/GitBell-X.Y.Z-arm64.dmg
shasum -a 256 release/GitBell-X.Y.Z.dmg
```

4. 検証する

```bash
brew style --cask kawabata324/gitbell/gitbell
brew audit --cask kawabata324/gitbell/gitbell
```

## 公式の homebrew-cask について

star / fork / watcher の下限（star なら 75 程度）があり、それを満たすまでは
受け付けられない。加えて未署名アプリは実質通らないので、Developer ID を
取得して公証を通すまでは、この tap で配ることになる。
