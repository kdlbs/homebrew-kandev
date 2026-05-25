# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.52.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.52.0/kandev-macos-arm64.tar.gz"
      sha256 "9d1876dfdf22f33e302058a05f1d768a96c69b343bd8c8bb83469753ad914396"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.52.0/kandev-macos-x64.tar.gz"
      sha256 "f3c11f5e699068328ddf8b6b3b91eee812a0bb5bca98f4cddf9d317ce51b5d03"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.52.0/kandev-linux-arm64.tar.gz"
      sha256 "7708eb46616e7dad3abd1566d0db967e3c8c52e8aa8af86e9c715f931c4acd1f"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.52.0/kandev-linux-x64.tar.gz"
      sha256 "bb9baf7fc5375827f84f559a340b6907a3740e52b890d1f5afb4f3156a77bdf2"
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
