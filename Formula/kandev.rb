class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.45.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.45.0/kandev-macos-arm64.tar.gz"
      sha256 "c890c0d380301e8656fb45b1a35a7a5ba4115e49812a5f2ae544a41e9aeed93c"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.45.0/kandev-macos-x64.tar.gz"
      sha256 "9fcaf6d3d5611df1536174ddcda610873c85d7b0aa7fb0a05ac4fca8ee1988eb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.45.0/kandev-linux-arm64.tar.gz"
      sha256 "d789356d9633890b27aa966e69af528341698e230a29b8e6928031c95ed2a7ac"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.45.0/kandev-linux-x64.tar.gz"
      sha256 "1d9d0734b9b9fa4ccf03b7fbecc6e3d6f6f0bfabdd85e2050a535ab5d25477d1"
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
