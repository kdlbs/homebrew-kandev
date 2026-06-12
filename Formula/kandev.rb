# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.58.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.58.0/kandev-macos-arm64.tar.gz"
      sha256 "479bf7b74dd42f2d183a49621c6fccb160f8eb1d1e9b7f4d25a6812f058a78be"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.58.0/kandev-macos-x64.tar.gz"
      sha256 "99f2a3058bc4ba55f4505b2b4a3ce6d488b219bb2b0c287581de474293a3f812"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.58.0/kandev-linux-arm64.tar.gz"
      sha256 "76e0f3786a042e95879da8815eef63ddd5bdb91b8cd9296cef72cd1f52c0d1c9"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.58.0/kandev-linux-x64.tar.gz"
      sha256 "ceb6b528ba491e56c17a18ebbf7c032f7526824702c5784bdadd8a2beb4e8a86"
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
