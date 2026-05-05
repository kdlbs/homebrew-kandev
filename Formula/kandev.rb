class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.39.1"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.39.1/kandev-macos-arm64.tar.gz"
      sha256 "416fd42d72fd5594a95bf412c290fb66b98b7506ad0378ebf3bf84f8f89f7db5"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.39.1/kandev-macos-x64.tar.gz"
      sha256 "3e888c783b7a1a371ca29304f170f813fd7e39c64b04f806477d683fd75e18d2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.39.1/kandev-linux-arm64.tar.gz"
      sha256 "22c24e190fec2b330b0dc80806e48a8108bdd124a1c397a738f1fc5938408bd3"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.39.1/kandev-linux-x64.tar.gz"
      sha256 "d81c2c9bb4b2bdef71b1b7dee1b16a486fb36780871b9b397cdb970bf067c0c3"
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
