# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.84.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.84.0/kandev-macos-arm64.tar.gz"
      sha256 "cbb5464c4aa0b8bdb0ed4af5c2709bf650d541842e3540587f94ab0761e47e2a"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.84.0/kandev-macos-x64.tar.gz"
      sha256 "91b0255467a8b1ad69e6f9946638e4d5ad2abb6c43ca887ff47acc6e56a04af4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.84.0/kandev-linux-arm64.tar.gz"
      sha256 "8380c980b41fd435da51003e7e2094b6c5833f7d3d321ca7462e03d95b192e95"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.84.0/kandev-linux-x64.tar.gz"
      sha256 "6abad5b6468309acee6b731636369904d1a0c2e5b13558f148c2a508fa7f9561"
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
