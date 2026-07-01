# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.71.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.71.0/kandev-macos-arm64.tar.gz"
      sha256 "29c5c6171bd4b8fd86721c6f1d54972a5122413b00ddec685d10440bd153c458"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.71.0/kandev-macos-x64.tar.gz"
      sha256 "7bfb31d8c3ba15c5db0a3c9506babd7505ff728e268dda76fbffbbaaaa295d70"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.71.0/kandev-linux-arm64.tar.gz"
      sha256 "2875da12c1330190753dd3512d33e86475676a1f8a618de3569b63f0fb92ee3c"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.71.0/kandev-linux-x64.tar.gz"
      sha256 "07a0b2aa8fa23226942a1931add416f93ec379b20059fcc3b45e9a19ef5c549e"
    end
  end

  def install
    libexec.install Dir["*"]
    # Create a stable wrapper at $HOMEBREW_PREFIX/bin/kandev that points at the
    # native launcher in the Cellar and sets the bundle/version env it uses to
    # find bin/.
    (bin/"kandev").write_env_script libexec/"bin/kandev",
      KANDEV_BUNDLE_DIR: libexec.to_s,
      KANDEV_VERSION:    version.to_s
  end

  test do
    assert_match "kandev launcher", shell_output("#{bin}/kandev --help")
  end
end
