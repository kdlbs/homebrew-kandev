# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.63.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.63.0/kandev-macos-arm64.tar.gz"
      sha256 "d304a640bd89947de30160dbcee7a058095f64235e9bdcf7ed11dfa2d3ba4a05"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.63.0/kandev-macos-x64.tar.gz"
      sha256 "ee32cc99b14f4d5dc0c481c2deac01af105b99a24c05f21fde348c61cb8b24d3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.63.0/kandev-linux-arm64.tar.gz"
      sha256 "671ea0a3afcb12d906e1c3a55e03aa9f00f4af1c65bccd20969843ccd838150f"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.63.0/kandev-linux-x64.tar.gz"
      sha256 "e58b41fa813d486b89b66483ac9a46f9c5801bb884c131facc197629c3b3271b"
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
