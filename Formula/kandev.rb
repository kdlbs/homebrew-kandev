class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.41.0"

  # Node is required: the CLI launcher and Next.js standalone server both need it.
  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.41.0/kandev-macos-arm64.tar.gz"
      sha256 "91fd2bf24a50ac888fe6d74ce856e23bb15b71ec7f024703af12a91c995421f0"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.41.0/kandev-macos-x64.tar.gz"
      sha256 "b8d52259bf4ef642c240e4c61f9b13d7438a02bbd3dd2148ddf5c57d99ea7270"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.41.0/kandev-linux-arm64.tar.gz"
      sha256 "93f60242922fe5ad85a0536baefb45ec8ea1feddf49bbb3636582dd9647e703b"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.41.0/kandev-linux-x64.tar.gz"
      sha256 "a08154766da7b78c3ca43f27f6cb5d50b21705b7498ca94c221f0bc47d1dab32"
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
