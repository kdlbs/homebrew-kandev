# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.64.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.64.0/kandev-macos-arm64.tar.gz"
      sha256 "3487fd1faf30d7190d221851607d8f98b7a69985cb962838f1371b7b757e2f09"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.64.0/kandev-macos-x64.tar.gz"
      sha256 "bd8c4a955e1206b98cb5d3db0ef4c965de32d51a07025acde81b332e09a784fd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.64.0/kandev-linux-arm64.tar.gz"
      sha256 "f7a729b12762fe65b628182cdb5511bdb935109574c4cd0e6e4eaa75692ea659"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.64.0/kandev-linux-x64.tar.gz"
      sha256 "3f7b32b913eabc4952a2eea0dde5c7e1e993babba0f0fa36fd4b3ee73139a819"
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
