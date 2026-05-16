class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.49.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.49.0/kandev-macos-arm64.tar.gz"
      sha256 "e0510b62383236d32c43f12139e632e594961c9a06b804105ddb1952e2089463"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.49.0/kandev-macos-x64.tar.gz"
      sha256 "d0cc9251400d16f01f1c52c14ac84f4e42abbdead62b96361b3b932df8c01abc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.49.0/kandev-linux-arm64.tar.gz"
      sha256 "f6289e94847dd8feb6e0f74930ac5976e401707e4ddcbb882faebbb7d81f2155"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.49.0/kandev-linux-x64.tar.gz"
      sha256 "675ae510a18ccda367aa55910fca31df7b3ea04d202394ad23e65f42c0cd967d"
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
