# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.57.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.57.0/kandev-macos-arm64.tar.gz"
      sha256 "ee4a1166fdffd8058d454598e7bd29735eb80f85425ff95e0cd41fc2df40ad29"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.57.0/kandev-macos-x64.tar.gz"
      sha256 "ad14f37d3c1cb2bb5ee439ec9947355e55136c68654cc1926853e0ecc1ce8f50"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.57.0/kandev-linux-arm64.tar.gz"
      sha256 "fd3ca6cafca615639bf69b7054465b77b709c32d0419d039cc984a355596be4a"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.57.0/kandev-linux-x64.tar.gz"
      sha256 "8e6e092ee419782651b6c0f30b99321579c5a24c46e0c35b48b2de8aa09a8ab6"
    end
  end

  def install
    libexec.install Dir["*"]
    # cli/bin/cli.js has #!/usr/bin/env node shebang. (bin/"kandev").write_env_script
    # creates a wrapper at $HOMEBREW_PREFIX/bin/kandev that sets KANDEV_BUNDLE_DIR
    # (so the CLI launcher finds bin/ and web/ in the Cellar) and KANDEV_VERSION
    # (read by run.ts at startup so the launcher logs "release: X.Y.Z" instead of
    # "release: (env)"). Calling write_env_script on the bin directory itself would
    # name the wrapper after the target's basename (cli.js), giving the wrong name.
    (bin/"kandev").write_env_script libexec/"cli/bin/cli.js",
      KANDEV_BUNDLE_DIR: libexec.to_s,
      KANDEV_VERSION:    version.to_s
  end

  test do
    assert_match "kandev launcher", shell_output("#{bin}/kandev --help")
  end
end
