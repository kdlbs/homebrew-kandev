# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.73.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.73.0/kandev-macos-arm64.tar.gz"
      sha256 "d87df0aa8e77edf5d4523cfec4ad93b85e8ab169c31327cb54a0b081ca907280"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.73.0/kandev-macos-x64.tar.gz"
      sha256 "b29ff1cad9075af0d904f5d910f8297f1e4aea3edb758e5c64f4fed3221b3868"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.73.0/kandev-linux-arm64.tar.gz"
      sha256 "a27fd6f67db596528d4f20730c80d40a6958fd788aa3bb126e5e54ae6ac81464"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.73.0/kandev-linux-x64.tar.gz"
      sha256 "c868e3fbd460a47b4c11e12e6544a481fa7f583ad532e0fbc65e5b296dcd96f5"
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
