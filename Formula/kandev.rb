# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.83.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.83.0/kandev-macos-arm64.tar.gz"
      sha256 "cefcf3796f07579ebd684e65e7f4dec207d9de05a149c51e6a13d3515539e753"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.83.0/kandev-macos-x64.tar.gz"
      sha256 "ac71628ce4c8cd3d4880839d5edd0eddca507a51cb12522db58b68747f653e7e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.83.0/kandev-linux-arm64.tar.gz"
      sha256 "d6290d47c386e718653c4868c4d60a1819c38f8dd6986791c9cd784ea0badb7b"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.83.0/kandev-linux-x64.tar.gz"
      sha256 "b99ff5e0b74e07ad5c7050fb31c173eb2bacc35da2e32fcd20c91f6b836ac37b"
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
