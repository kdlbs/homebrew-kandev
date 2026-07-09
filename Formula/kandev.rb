# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.76.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.76.0/kandev-macos-arm64.tar.gz"
      sha256 "993a8b62c0bee44ed3612bcf29f61af99ffdfd884460d988d57c28545dbd3a43"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.76.0/kandev-macos-x64.tar.gz"
      sha256 "a12004d09a3fd2977c178adc3916be5c472015939e62615a605f6e34ea4d74f4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.76.0/kandev-linux-arm64.tar.gz"
      sha256 "958c3d60b975c55ba327b9413b5ffc3f68742c9d64af698c4df7b0545491341a"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.76.0/kandev-linux-x64.tar.gz"
      sha256 "f3932c557e17201de9c8a0c3312e2a7422e2e2d80828948f304f838b328c4f24"
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
    assert_match "kandev launcher", shell_output("#{bin}/kandev --help")
  end
end
