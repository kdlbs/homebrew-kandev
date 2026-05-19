class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.50.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.50.0/kandev-macos-arm64.tar.gz"
      sha256 "a2f2a3a1c1faaf5d9fcefc343038ed72dfaf6d6c5f555b2fabf4e888d6f599c3"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.50.0/kandev-macos-x64.tar.gz"
      sha256 "bcb3069680a3f2df3a09aad42f7921dde96ac78f1d709d09689ac8cf24d64185"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.50.0/kandev-linux-arm64.tar.gz"
      sha256 "a901c7427d2b6333797b0eabc263981b6bd3fe2357289f8dc4051bd30e2ca81d"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.50.0/kandev-linux-x64.tar.gz"
      sha256 "36e3540b3f13f100f9ef33d3464b3d6f8246d23d2065856a9c8c8865dfc7b146"
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
