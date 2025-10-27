cask "autobds" do
  version "0.2.1"

  # Architecture-specific downloads
  if Hardware::CPU.arm?
    url "https://pub-c378a27ce1204d59aadecec2b7e4f969.r2.dev/v#{version}/autoBDS-#{version}-arm64.dmg"
    sha256 "4b402abbd4306a900eca6f5393496460e9b881a8b59814dc5e750c9d87588053"  # TODO: Update after uploading v0.2.1 DMG
  else
    url "https://pub-c378a27ce1204d59aadecec2b7e4f969.r2.dev/v#{version}/autoBDS-#{version}.dmg"
    sha256 "1ca6e9912b1b99487404b0fd2454f8ebb5660ee7b3d3aa0d1309baecbb1ea875"  # TODO: Update after uploading v0.2.1 DMG
  end

  name "autoBDS"
  desc "Automated real estate listing poster for Vietnam"
  homepage "https://www.autobds.vn"

  livecheck do
    url "https://api.autobds.vn/api/releases/latest"
    strategy :json do |json|
      json["tag_name"]&.delete_prefix("v")
    end
  end

  app "autoBDS.app"

  # Remove quarantine attribute after installation
  # Required for unsigned/adhoc-signed apps
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-rd", "com.apple.quarantine", "#{appdir}/autoBDS.app"],
                   sudo: false
  end

  uninstall_postflight do
    # No cleanup needed
  end

  zap trash: [
    "~/Library/Application Support/autoBDS",
    "~/Library/Preferences/com.autobds.desktop.plist",
    "~/Library/Saved Application State/com.autobds.desktop.savedState",
  ]

  caveats <<~EOS
    🎉 autoBDS installed successfully!

    To get started:
      1. Press Cmd+Space and type "autoBDS"
      2. Sign in with your account from autobds.vn
      3. Start posting real estate listings automatically!

    Need help? Visit: https://www.autobds.vn/how-it-works
  EOS
end
