# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  # Conditional asset names end in x64/arm64; without this, Homebrew uses version 64.
  version "0.86.1"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.86.1/kandev-macos-arm64.tar.gz"
      sha256 "3efa5ad89a911b7bcb73fa8c8c60384f1b6bda87505f2f70c0bf37d54234940b"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.86.1/kandev-macos-x64.tar.gz"
      sha256 "6ab94b0a3a423e6cb21ef5253199e3723ff58a566c9f76736e3e27c436037343"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.86.1/kandev-linux-arm64.tar.gz"
      sha256 "682571d6f2d79f828be74bba88af6b398fc5a4a6ff8d5689a928316f203872ed"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.86.1/kandev-linux-x64.tar.gz"
      sha256 "676218ed19fadfe855719f014ab9529f0cfe45a8c44b47ca0c1386e80808a1f2"
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
