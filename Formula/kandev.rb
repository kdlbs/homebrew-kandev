# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.74.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.74.0/kandev-macos-arm64.tar.gz"
      sha256 "1be7eaca30f0390d9948092448aa53476d62f6af81af09a7d5ab7ffcc093b0d8"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.74.0/kandev-macos-x64.tar.gz"
      sha256 "d7fb734afc6a968f22dd1ea8a15c2ae044403c5dddeed254be8cbafaaf86cc40"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.74.0/kandev-linux-arm64.tar.gz"
      sha256 "8167cc3c1855f48f927cbe4c0b742b6618ad15aa2cc9237c63c94c44e750035c"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.74.0/kandev-linux-x64.tar.gz"
      sha256 "d4cc51cd2d41c05dac609dd08efd50ebe663d38b21bbb9f5a6809e2b74812c17"
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
