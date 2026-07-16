# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.79.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.79.0/kandev-macos-arm64.tar.gz"
      sha256 "345244a499ee98ce95a6db22107f16ea81cdfa9ec4a03348f3a4a5b61a4b110e"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.79.0/kandev-macos-x64.tar.gz"
      sha256 "e7dbbea4360483bfef957dea1daf4e6846e8d6f81f7a646d85bf785ba1504b3a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.79.0/kandev-linux-arm64.tar.gz"
      sha256 "c837db7ee7c4f28b62b39a9c0fcb3b0170fdff2fa87ede8fdbe1cf822c143283"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.79.0/kandev-linux-x64.tar.gz"
      sha256 "f0511a3346535caaf3caa5961a8ee55245a4011f85293649c205eb431c97001d"
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
