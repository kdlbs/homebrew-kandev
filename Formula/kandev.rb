# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.53.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.53.0/kandev-macos-arm64.tar.gz"
      sha256 "fb60eedca4cf6ccefda0e2e34f4c1991c8595d37ff105ff3bdc10c65f67ac642"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.53.0/kandev-macos-x64.tar.gz"
      sha256 "29e7586d1718001053dee8bcd6c34dad93cfbf6eda3a930463258f20e6611b7a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.53.0/kandev-linux-arm64.tar.gz"
      sha256 "75274ff02b6a34ee27fcbe03b722e1e9f943ddfc31b08b1ceeda94cab455e296"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.53.0/kandev-linux-x64.tar.gz"
      sha256 "311a2003770691bd0779ee7be6fe41000966fd013ad289fd39afa9210f24f402"
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
