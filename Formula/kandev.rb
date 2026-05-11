class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.42.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.42.0/kandev-macos-arm64.tar.gz"
      sha256 "db6a4eaee9f325ef6576ceb7feed3c8d7ddfafe7fb76f4b84dc3fb9d947ed380"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.42.0/kandev-macos-x64.tar.gz"
      sha256 "472ef71e9d6c1fccc17f247b78a683aa3308e29f5fce52227924aec2cc0a0182"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.42.0/kandev-linux-arm64.tar.gz"
      sha256 "cbe1fad9357ec1b77508c4649da78eeb92e75b7b412d98d3d58f925e3e485415"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.42.0/kandev-linux-x64.tar.gz"
      sha256 "fdd0140003b96ee6746f04604f9a3a87ecac1d5aba7f3ca2a2635aa324bcffb9"
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
