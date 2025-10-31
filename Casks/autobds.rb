cask "autobds" do
  version "0.2.6"

  # Architecture-specific downloads
  if Hardware::CPU.arm?
    url "https://pub-c378a27ce1204d59aadecec2b7e4f969.r2.dev/v#{version}/autoBDS-#{version}-arm64.dmg"
    sha256 "80ef2adba53a77c41762f938622062a458f3b5ca1ed24c51e1c8f5a57f0ee962"  # TODO: Update after uploading v0.2.1 DMG
  else
    url "https://pub-c378a27ce1204d59aadecec2b7e4f969.r2.dev/v#{version}/autoBDS-#{version}.dmg"
    sha256 "558bd563e33fe43d26eb13a063759e54106259140c51e4353d095ec7778d71e4"  # TODO: Update after uploading v0.2.1 DMG
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
