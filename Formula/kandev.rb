# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.55.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.55.0/kandev-macos-arm64.tar.gz"
      sha256 "41814dc7732287f9b1c4efccc34eaac861c23bce365e6336613a94c60fb533b3"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.55.0/kandev-macos-x64.tar.gz"
      sha256 "7506c98d775e92e3cf9cefd40775fb580aa939cbff5ed5662f395f476f09d299"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.55.0/kandev-linux-arm64.tar.gz"
      sha256 "e1c61c834dd85469508613ba9aa55341a90c596e06697f0d7aac4895940eec32"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.55.0/kandev-linux-x64.tar.gz"
      sha256 "f0ec96813fb74057d41a9f7c2d06210989be9b08cf994c4a2a015e16c5755426"
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
