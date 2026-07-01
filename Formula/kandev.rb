# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.70.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.70.0/kandev-macos-arm64.tar.gz"
      sha256 "82b0dca192518696488e54b194b9490a30c39808a0e6605ffe9bc02ed2937605"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.70.0/kandev-macos-x64.tar.gz"
      sha256 "c055cd1cf25288cec734082553ea89b7f5f9aed93707f3a038bcd9613df4b297"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.70.0/kandev-linux-arm64.tar.gz"
      sha256 "c99065a0f21e0c04822cd32e527df3ae3e3724499a4dd9fa701c5132b24faa36"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.70.0/kandev-linux-x64.tar.gz"
      sha256 "b186ea7fa4f33b4b22281c440e86ea3b5b31b11cbb18a569c7ca6c9e9ea5835a"
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
