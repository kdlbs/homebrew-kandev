class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.40.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.40.0/kandev-macos-arm64.tar.gz"
      sha256 "28ad8cf07a30a946ffd4029727b28e3296b1dbcb164a8808fac330a2ccb2752c"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.40.0/kandev-macos-x64.tar.gz"
      sha256 "cad58c88a5502d15bf14ff9e02664b68a60371f70d48aab85e5a4737b115336e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.40.0/kandev-linux-arm64.tar.gz"
      sha256 "ecfd8c1df0da35b632978bf551a4a15a144b103abd6080e65f942cf1b90fe71d"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.40.0/kandev-linux-x64.tar.gz"
      sha256 "287c42634de52cf90758d8c0cd6fcf99a5d0c8c5d72e301e00e986c9d0b839bb"
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
