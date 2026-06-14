# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.59.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.59.0/kandev-macos-arm64.tar.gz"
      sha256 "c730ff54cb2396517e90d5689f3e50a03613123e6130f9f94fa2d22462d5ea4d"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.59.0/kandev-macos-x64.tar.gz"
      sha256 "86a86f2557cdcf5bcc46519230824d969ec0d189bad25b58e4185d2b038b1515"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.59.0/kandev-linux-arm64.tar.gz"
      sha256 "5fe3f5a78973d74a1b89c357b68c3fdf052df5adfb489b1ac4f6a54c3428712e"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.59.0/kandev-linux-x64.tar.gz"
      sha256 "af7877e334784c55eb88ff84632eb552a8f11c47133a9651d8a5f99fc14be37d"
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
