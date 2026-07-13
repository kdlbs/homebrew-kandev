# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.78.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.78.0/kandev-macos-arm64.tar.gz"
      sha256 "f7889f6d8374d516ed58be3c621284c2144e741ff4ea0990c5706c672253e364"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.78.0/kandev-macos-x64.tar.gz"
      sha256 "96b9d5cb919c7d25d4ac3bce9f3468319034c699aadf14c6ab659fbdff7f8e03"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.78.0/kandev-linux-arm64.tar.gz"
      sha256 "6aa0f42f30797e124b274ec5df81561d4d0d908aad50c0a774c3d2dba69c798c"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.78.0/kandev-linux-x64.tar.gz"
      sha256 "fb89bc837739645de40fea0c4d8c9968a861ed261585a3b2e8cd9898b5a77017"
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
