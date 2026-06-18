# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.65.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.65.0/kandev-macos-arm64.tar.gz"
      sha256 "60ce0e9b1252a873e87848378d09bbce9d8b890401c6e8c5afd15e9ecec29a75"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.65.0/kandev-macos-x64.tar.gz"
      sha256 "846142f05c17f6c5e5c760c5eb2b52fa1792033378bacc1d11d71442433868c3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.65.0/kandev-linux-arm64.tar.gz"
      sha256 "b37e6a79e5e7514f6219bac09a7363e057a1cc44093b43a41959aa94bc196632"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.65.0/kandev-linux-x64.tar.gz"
      sha256 "369c9db9e3db5811d0c0ebc6a376c295a54b5e21b9306727ce6362d16c52da88"
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
