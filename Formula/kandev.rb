# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
require "json"

class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  # Conditional asset names end in x64/arm64; without this, Homebrew uses version 64.
  version "0.97.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.97.0/kandev-macos-arm64.tar.gz"
      sha256 "b7c74d1e1124453bbf60360d382992789bf91e311e14ff7ff0be9220cb6ad88c"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.97.0/kandev-macos-x64.tar.gz"
      sha256 "95f801319565fc79032b366f85a3b520efb1c136f5eb06542ddcf25d2a25a1ce"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.97.0/kandev-linux-arm64.tar.gz"
      sha256 "3bba944aa4f73441864203c1a84a96e09bcdfc18d01c32cfbb8ba664b2c6b823"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.97.0/kandev-linux-x64.tar.gz"
      sha256 "d15b5ca901fc051dfefbb40a2e0fbec8e92aaf16db8225921f32a6ccdc7d2457"
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
    manifest_path = libexec/"remote-helpers.json"
    manifest = JSON.parse(manifest_path.read)
    assert_equal 1, manifest.fetch("schema_version")
    assert_equal "standard", manifest.fetch("variant")
    assert_equal "v#{version}", manifest.fetch("version")

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
