# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.75.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.75.0/kandev-macos-arm64.tar.gz"
      sha256 "33134e1c62d39aae5aa138818a7af4a87d51d81bdc09425980d1a34eddb625f2"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.75.0/kandev-macos-x64.tar.gz"
      sha256 "fff5fd3657fc710b335af1230307fda51c50734cd46de9521a93bbc8710fd896"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.75.0/kandev-linux-arm64.tar.gz"
      sha256 "4718d77b659974ec6eac39778f9d297561703f687d116aa77813b5d49bda79de"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.75.0/kandev-linux-x64.tar.gz"
      sha256 "338037c6b9c2e731fb96b8affad45ce164a2a349659d00a0b2f270afcf21c8b3"
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
