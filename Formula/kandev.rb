# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.81.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.81.0/kandev-macos-arm64.tar.gz"
      sha256 "c1a464c5eafa9758b1eb2b7605923f3a3f957a17ecd0cd18896e0e9170a4083b"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.81.0/kandev-macos-x64.tar.gz"
      sha256 "21cd942bcacd969ff38aeb95c1df1af49798c928e873eae2ee2ec3fcb2a2aceb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.81.0/kandev-linux-arm64.tar.gz"
      sha256 "6153c816dff5abef79f3c6f442727d91dceed643be56d7848303d99cb1f70277"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.81.0/kandev-linux-x64.tar.gz"
      sha256 "da051194953d83d15afe127fa4755e7838d4ba0b0c117b1c5f49a9c8c7b87d31"
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
