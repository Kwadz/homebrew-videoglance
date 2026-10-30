cask "videoglance" do
  version "1.1,46"
  sha256 "3027b9053a7d4d7ed2e226cec20009034fa9a2470dde30db7856d9bc2ff5131c"

  url "https://github.com/Kwadz/videoglance-site/releases/download/v#{version.csv.first}-#{version.csv.second}/VideoGlance-#{version.csv.first}-#{version.csv.second}-arm64.dmg"
  name "VideoGlance"
  desc "Video previews and thumbnails in Finder"
  homepage "https://videoglance.app/"

  # Release tags are v<version>-<build>; the cask version is <version>,<build>.
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)-(\d+)$/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      "#{match[1]},#{match[2]}"
    end
  end

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "VideoGlance.app"

  # Stop running Quick Look extensions before Homebrew removes the app.
  uninstall_preflight_steps do
    terminate_process "VideoGlanceQL"
    terminate_process "VideoGlanceThumbnail"
  end

  uninstall quit: [
    "com.videoqlplugin.VideoGlance",
    "com.videoqlplugin.VideoGlance.preview",
    "com.videoqlplugin.VideoGlance.thumbnail",
  ]
end
