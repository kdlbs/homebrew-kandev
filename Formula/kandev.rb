# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.69.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.69.0/kandev-macos-arm64.tar.gz"
      sha256 "5f3c93b7deb50bbd2402df9b8301f8c58247c2082103f3bd530c185aaa21a6a9"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.69.0/kandev-macos-x64.tar.gz"
      sha256 "91f486a9a855bcae649a3e8ac070347e64dac66f7414b4016ebcc083072e8c45"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.69.0/kandev-linux-arm64.tar.gz"
      sha256 "ec60213e4d8696c8f7cf8f0a87e13e869c498c9457d0a32fd8fd105cd825599d"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.69.0/kandev-linux-x64.tar.gz"
      sha256 "5c8adea806aa7e0a73bf9bb7b325445c4c6cdb02c1cf685e2ecb0e9d6de1f2f2"
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
