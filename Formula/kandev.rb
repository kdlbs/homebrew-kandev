# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.67.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.67.0/kandev-macos-arm64.tar.gz"
      sha256 "14807c6f232601ffb87c1556b44bc6ddad90856533aef41c6b46a16f498237c4"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.67.0/kandev-macos-x64.tar.gz"
      sha256 "b86accbe203725939b7bd91810cea43b54b72712c38e4f8b6a7885b1af4a32e6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.67.0/kandev-linux-arm64.tar.gz"
      sha256 "ea690eafeb7b2f7446c2752217c36078bf5d4513d0e4db04e1711d4858fd7684"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.67.0/kandev-linux-x64.tar.gz"
      sha256 "3fcecf712b8d3fb89028d749708354af95a5dd4698b66767205f731949602175"
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
