# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  # Conditional asset names end in x64/arm64; without this, Homebrew uses version 64.
  version "0.86.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.86.0/kandev-macos-arm64.tar.gz"
      sha256 "01dc9454e9389a3ddc72ade0b0e86afd89fa8ae8c2182ca7ed283c328a2e2442"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.86.0/kandev-macos-x64.tar.gz"
      sha256 "cba5e18e5d0526024084f95c9b8e12e588d599e880915c80f68dee26f1350cfe"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.86.0/kandev-linux-arm64.tar.gz"
      sha256 "7494f2d7da5961672440c7aeed036b38aa4d6e233f477ee41c7a3338d0b5b8b5"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.86.0/kandev-linux-x64.tar.gz"
      sha256 "768638463c7e53be76b2422a3c8f1b8bf594740ad842435a4dfe7d2a2f32cc74"
    end
  end

  def install
    libexec.install Dir["*"]
    # Create a stable wrapper at $HOMEBREW_PREFIX/bin/kandev that points at the
    # native launcher in the Cellar and sets the bundle/version env it uses to
    # find bin/.
    (bin/"kandev").write_env_script libexec/"bin/kandev",
      KANDEV_BUNDLE_DIR: libexec.to_s,
      KANDEV_VERSION:    version.to_s
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/kandev --version").strip

    ENV["KANDEV_HOME_DIR"] = testpath.to_s
    ENV["KANDEV_DATABASE_PATH"] = (testpath/"kandev.db").to_s
    ENV["KANDEV_SERVER_HOST"] = "127.0.0.1"
    port = free_port
    pid = spawn bin/"kandev", "--headless", "--port", port.to_s
    health_url = "http://127.0.0.1:#{port}/health"
    curl = "curl --silent --show-error --fail --retry 30 --retry-connrefused --retry-delay 1"
    health = shell_output("#{curl} #{health_url}")
    assert_match '"status":"ok"', health
    assert_match "<title>Kandev</title>", shell_output("#{curl} http://127.0.0.1:#{port}/")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
