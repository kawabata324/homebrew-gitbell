cask "gitbell" do
  version "0.1.1"

  on_arm do
    sha256 "c7da91cda7c71940e95d410d952b669d7db2455532911c3c18e4aa2f127e0180"

    url "https://github.com/kawabata324/gitbell/releases/download/v#{version}/GitBell-#{version}-arm64.dmg",
        verified: "github.com/kawabata324/gitbell/"
  end
  on_intel do
    sha256 "5542c859177d2d3c8ccb612603307227baafc8e7f5b1448ca50adf0c8d12014d"

    url "https://github.com/kawabata324/gitbell/releases/download/v#{version}/GitBell-#{version}.dmg",
        verified: "github.com/kawabata324/gitbell/"
  end

  name "GitBell"
  desc "Menu bar client for GitHub notifications"
  homepage "https://github.com/kawabata324/gitbell"

  # 新しいリリースは GitHub の latest タグから拾う。
  livecheck do
    url :url
    strategy :github_latest
  end

  # Info.plist の LSMinimumSystemVersion と揃える。
  depends_on macos: :monterey

  app "GitBell.app"

  zap trash: [
    "~/Library/Application Support/GitBell",
    "~/Library/Preferences/com.kawabata324.gitbell.plist",
    "~/Library/Saved Application State/com.kawabata324.gitbell.savedState",
  ]

  # Apple Developer ID による署名がまだ無いので、Gatekeeper に止められる。
  # brew の --no-quarantine は今の Homebrew では受け付けないため、後から外してもらう。
  caveats <<~EOS
    GitBell is not signed with an Apple Developer ID yet, so macOS quarantines
    it and refuses to open it. After installing, clear the flag:

      xattr -dr com.apple.quarantine "#{appdir}/GitBell.app"

    Or open Finder, right-click GitBell and choose Open.
  EOS
end
