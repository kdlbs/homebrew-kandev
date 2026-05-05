class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.39.2"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.39.2/kandev-macos-arm64.tar.gz"
      sha256 "7aa4d3fabb8b0413e32146dd92f590315250928c05046b16e922ba710628030f"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.39.2/kandev-macos-x64.tar.gz"
      sha256 "33c6caab203d05d18ba285fb0b312c67f9bdaffc2415f4bdca0a0c1c0d4f65ad"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.39.2/kandev-linux-arm64.tar.gz"
      sha256 "caf65eb931708f9d0827e57f6396c8df690112cc1c7d735bf493bed13ddefb66"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.39.2/kandev-linux-x64.tar.gz"
      sha256 "d170a286f631c487cec64ea356355ce2ab60bdaa1e3fd1bb47d57b520224387d"
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
