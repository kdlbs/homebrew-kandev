# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  # Conditional asset names end in x64/arm64; without this, Homebrew uses version 64.
  version "0.91.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.91.0/kandev-macos-arm64.tar.gz"
      sha256 "c422c49eb32e29ab9a1f05e97c6069433897f8d96b07734c02eb600572d47a5c"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.91.0/kandev-macos-x64.tar.gz"
      sha256 "6b0af8dd83ef08e8c7a073eb8a4e25557685c4d43687134b40f57c326e0e385c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.91.0/kandev-linux-arm64.tar.gz"
      sha256 "a5d09792cfacfb81af7d10163d4829230bd9ca1bdbbbd691f3d1f3f875b23d1c"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.91.0/kandev-linux-x64.tar.gz"
      sha256 "5b087790b9446ae13d9ed397828f85eef316b59ac1f54b5621827e5c3e47531f"
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
