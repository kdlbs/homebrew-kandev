class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.43.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.43.0/kandev-macos-arm64.tar.gz"
      sha256 "f032c166efd774ae93cf9901f23df6f255955c46b03e9f73dcb6041ec9db2204"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.43.0/kandev-macos-x64.tar.gz"
      sha256 "bda5b0ccd7316d2e52f5d16cb405d02814abde306abb87aa2607e8eea5b0702c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.43.0/kandev-linux-arm64.tar.gz"
      sha256 "eef0dde7f6881e6fd14626eaf9c6cb9f5bf26714ce1d9f82e782dd32732aaf37"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.43.0/kandev-linux-x64.tar.gz"
      sha256 "7eb25d10ca05bf135ce24378cb1636c3b9c1ac8eeb13b22e893cf47dba90a4c9"
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
