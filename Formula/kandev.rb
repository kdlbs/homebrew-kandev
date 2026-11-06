# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
require "json"

class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  # Conditional asset names end in x64/arm64; without this, Homebrew uses version 64.
  version "0.99.1"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.99.1/kandev-macos-arm64.tar.gz"
      sha256 "021ccd84f33fc6df49a1ccbc5802935fe97d9f350fcad50128186a4e6bcc3c88"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.99.1/kandev-macos-x64.tar.gz"
      sha256 "ec5240c7f5b7cecf9c45a411e2451913fb5d05c0e4ba1476423c5d01520a85e3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.99.1/kandev-linux-arm64.tar.gz"
      sha256 "125e45f25365606877da86e97dd828f1d22d376b24ff1ccf80dd2a992a40d5c4"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.99.1/kandev-linux-x64.tar.gz"
      sha256 "fa6196af489f18477ad04a79fd276f16e69f536552a28c15efc8fc4d2745259a"
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
