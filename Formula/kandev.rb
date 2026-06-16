# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.61.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.61.0/kandev-macos-arm64.tar.gz"
      sha256 "00fb420050ef6b8e59b8e2156aeadbfbbf069136369f489843c75616f76f8068"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.61.0/kandev-macos-x64.tar.gz"
      sha256 "915d3c7fbc2408cbc2eadc1e67a46254549c843adc5e185f4abdc0c304c7b1e6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.61.0/kandev-linux-arm64.tar.gz"
      sha256 "8c002151000c46e5ae80f2ad9f90a10ec85b7f88ea5914b3ea09927e3a596152"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.61.0/kandev-linux-x64.tar.gz"
      sha256 "e29e01e91fe9ad51cd7d090f1645b193c57639a16008aafc8a5b4d0d8bb48638"
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
