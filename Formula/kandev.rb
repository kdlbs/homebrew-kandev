class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.44.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.44.0/kandev-macos-arm64.tar.gz"
      sha256 "cafb5c7664da705c2cd338203b4e15158e883c1a45f8664687c9a8a26f6dd9a7"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.44.0/kandev-macos-x64.tar.gz"
      sha256 "d39b1893c9a4a25d4a524a6b136fe66ac18adff505b92144d32c95c3c857ad80"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.44.0/kandev-linux-arm64.tar.gz"
      sha256 "ae381b953e24bf2f19dfe2abb4f840ffdae4e00c703f840c39e68d3b9cb41495"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.44.0/kandev-linux-x64.tar.gz"
      sha256 "223220cf1041025bf8c765f1f97bce6e751fba6deaa1420b93768e733c5db844"
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
