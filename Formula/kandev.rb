# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.84.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.84.1/kandev-macos-arm64.tar.gz"
      sha256 "428614512ac7ef59e5872f22f913b19775bd38b769326f50781045ebd208b5a9"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.84.1/kandev-macos-x64.tar.gz"
      sha256 "6fde4f694fabb4819fdb6d962879cf818d039221c1d1ad6e5c1c286bf7dce392"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.84.1/kandev-linux-arm64.tar.gz"
      sha256 "ef6d968b8eb4c3d3068ec1fec0f8664757af51b5c2fc9fd70fa6244e35d65756"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.84.1/kandev-linux-x64.tar.gz"
      sha256 "2e0de4124d609ca1565081266ba1465a727b425c769fe814e3604162b12bb6a9"
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
