# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
require "json"

class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  # Conditional asset names end in x64/arm64; without this, Homebrew uses version 64.
  version "0.103.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.103.0/kandev-macos-arm64.tar.gz"
      sha256 "40852121ddb84d932e75b77634e495494b6b8ed4a7f29b3ee79e4eec13f61b77"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.103.0/kandev-macos-x64.tar.gz"
      sha256 "1fc01aa4706dd55ff9b88110cdffa852d602057d8ba04238f3b4d036e260cbc7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.103.0/kandev-linux-arm64.tar.gz"
      sha256 "b3fe846ff22a24bdd2ed03e75b50692c4b2c7c46fa3976808e6bac78a2c49500"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.103.0/kandev-linux-x64.tar.gz"
      sha256 "df39be94820af9b4f82635f575b818c6bde2e30b41ffb15c96828398f2575eae"
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
