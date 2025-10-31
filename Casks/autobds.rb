cask "autobds" do
  version "0.2.4"

  # Architecture-specific downloads
  if Hardware::CPU.arm?
    url "https://pub-c378a27ce1204d59aadecec2b7e4f969.r2.dev/v#{version}/autoBDS-#{version}-arm64.dmg"
    sha256 "f1401ae1d42a9cad61a2868de38e3d083e046f4d7a7b0cd5a9d030a5a60c3023"  # TODO: Update after uploading v0.2.1 DMG
  else
    url "https://pub-c378a27ce1204d59aadecec2b7e4f969.r2.dev/v#{version}/autoBDS-#{version}.dmg"
    sha256 "054540c80c2e72ea9a33a15dd5ac6e7b2cd88e1addd56fe15c946bef0f5ebe13"  # TODO: Update after uploading v0.2.1 DMG
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
