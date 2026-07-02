# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.72.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.72.0/kandev-macos-arm64.tar.gz"
      sha256 "9c8339febb7c4735f211e01092ff0f844129c818237837c64df7e018b39f628c"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.72.0/kandev-macos-x64.tar.gz"
      sha256 "7021d13b0509b9a83bda8c2feb990bfeb7171bf0f81dd542cf9a371a4e518420"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.72.0/kandev-linux-arm64.tar.gz"
      sha256 "18a49dce6090f1b2d454eafe9b70fc3db7abe30617933f3bf8ccceb111d8854e"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.72.0/kandev-linux-x64.tar.gz"
      sha256 "68d0da9f568b9ee1d319bdc8edf2b33f3a591be86bf03eb6edd1a76f2faa5fac"
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
