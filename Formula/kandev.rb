# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  # Conditional asset names end in x64/arm64; without this, Homebrew uses version 64.
  version "0.94.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.94.0/kandev-macos-arm64.tar.gz"
      sha256 "ad970e08f15c773131ead0623e65fba3a2b7cf293e7e0c0158e76ab6f82275be"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.94.0/kandev-macos-x64.tar.gz"
      sha256 "ae1c2788b116eb00ac488ac5182343b9cdbaeb6f66ff50ccc4827aa0d2caf779"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.94.0/kandev-linux-arm64.tar.gz"
      sha256 "3f68f4fffc86c04c66e38becad4bbc0e196ac987252ad4d84ad54eb9e7140ba8"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.94.0/kandev-linux-x64.tar.gz"
      sha256 "3acc1365839bcf698017f3fee59b9bf12d4efeebc327751905bf13d33b2bbd72"
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
    # /health flips to 200 as soon as the listener binds, before startup
    # recovery finishes, so curl's --retry (which only retries on
    # connection-refused/5xx, never on 200) would stop waiting immediately.
    # /ready holds at 503 until the app is actually usable.
    ready_url = "http://127.0.0.1:#{port}/ready"
    curl = "curl --silent --show-error --fail --retry 30 --retry-connrefused --retry-delay 1"
    ready = shell_output("#{curl} #{ready_url}")
    assert_match '"status":"ok"', ready
    assert_match "<title>Kandev</title>", shell_output("#{curl} http://127.0.0.1:#{port}/")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
