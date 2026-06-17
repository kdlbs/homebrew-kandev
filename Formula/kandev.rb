# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.62.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.62.0/kandev-macos-arm64.tar.gz"
      sha256 "983de8f61076316109bc8419d6e4e2ed6fe62b751eeffbbccdae6be1be180e57"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.62.0/kandev-macos-x64.tar.gz"
      sha256 "c785c8c314caf20396da39baca81a2dc18dc52ef77c374355b995fc790f3cfba"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.62.0/kandev-linux-arm64.tar.gz"
      sha256 "fd084925b72e379bc9377790d30d8536215a02f3ab734da47b64e1530e217aed"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.62.0/kandev-linux-x64.tar.gz"
      sha256 "6d7581b0df61da4d8cf93b07fa160c7d4cb568eae8664a2d3e3695b5c41fa314"
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
