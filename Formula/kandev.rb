# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.80.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.80.0/kandev-macos-arm64.tar.gz"
      sha256 "e731fb8e15f5d9fc9ca652955eb3e0b7714aaf889f9630c7cfe451fa163bc16b"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.80.0/kandev-macos-x64.tar.gz"
      sha256 "8e391ba1929eb931bf621a234aaa92223f6fabc41448e252f1017477eba86e9c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.80.0/kandev-linux-arm64.tar.gz"
      sha256 "a738d2fe2febaaeee8b2f3359b191c9e6fa1253d957ce49b120cf84d3f5c2a06"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.80.0/kandev-linux-x64.tar.gz"
      sha256 "0ace06e77d7e5e02e90bfe1b63faa77f1701cbcfccf7cc58547cbd2e47206d0b"
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
