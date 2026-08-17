# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  # Conditional asset names end in x64/arm64; without this, Homebrew uses version 64.
  version "0.89.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.89.0/kandev-macos-arm64.tar.gz"
      sha256 "09d08f373d0016f21e88b3573a9c8996aeab0c93cd9feeb51674e72249ddbccc"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.89.0/kandev-macos-x64.tar.gz"
      sha256 "c886cb3180dbb856d4ca8b1a33bc17b361b81a9a438ec6a08aeae70aec738eb0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.89.0/kandev-linux-arm64.tar.gz"
      sha256 "7cb00a95113368ae3e40fff292e4251163bbf5664cda0b5903e606914b9767a5"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.89.0/kandev-linux-x64.tar.gz"
      sha256 "be7eb8edc0049cb10531c65f4136a26678243723d406c261455189413eb6f922"
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
