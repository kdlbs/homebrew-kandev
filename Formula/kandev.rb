# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.77.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.77.0/kandev-macos-arm64.tar.gz"
      sha256 "6d0a983cea15e9c4c635ea53dbcc8d2cebce5b6bc7baf5a5412d16483275aab7"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.77.0/kandev-macos-x64.tar.gz"
      sha256 "490a70ebcc82aa3dd8de90248e7c7c23333f63999e5c9ebe0710378fb995277b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.77.0/kandev-linux-arm64.tar.gz"
      sha256 "9bfd61c38b4085583f5d768553e8ad16a853e1c1de96123b287fbebcf7185e68"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.77.0/kandev-linux-x64.tar.gz"
      sha256 "263deef3c26605e61069bb9fde715ec30f0bccefa11117e088fb2adbcde73b84"
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
