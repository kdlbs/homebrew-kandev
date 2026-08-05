# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  version "0.85.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.85.0/kandev-macos-arm64.tar.gz"
      sha256 "3b3947997333794aac65d8ec817cce48c5a8360c9248bc852b110976f0dbfd43"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.85.0/kandev-macos-x64.tar.gz"
      sha256 "c47d7290713f054f4878dff0721c378dc7c72a5c0f6d72ff5fdd31c15b9a2c69"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.85.0/kandev-linux-arm64.tar.gz"
      sha256 "b8d2a89a4d9cc62ac62bba8933debda0fb05b61d57a7b9104f842eeef95a081d"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.85.0/kandev-linux-x64.tar.gz"
      sha256 "18b18df24f960b5ee560d5cb42af3c1365611b06e95e45804e4607f8fc5810ee"
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
