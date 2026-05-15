class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.48.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.48.0/kandev-macos-arm64.tar.gz"
      sha256 "b87202239c5053be29cb797f57e780ecde349ec4e3b5e22e2ab8d8547ec19a8c"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.48.0/kandev-macos-x64.tar.gz"
      sha256 "a23bf025456ab93dd993267ed5c8367b10eaa24377cb003df7b1185141b115ca"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.48.0/kandev-linux-arm64.tar.gz"
      sha256 "3fb1d5e6216897727051a025429f418c330b2c3e2c309bdb3c42a043ebee3ed8"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.48.0/kandev-linux-x64.tar.gz"
      sha256 "f1029ec01236093b13636abc3407a6983712899c61abc7d359701f1dfe9819de"
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
