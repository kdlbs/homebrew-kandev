# Template used by update-homebrew-tap.sh. Placeholder strings are replaced at
# release time before this formula is pushed to kdlbs/homebrew-kandev.
class Kandev < Formula
  desc "Manage tasks, orchestrate agents, review changes, and ship value"
  homepage "https://github.com/kdlbs/kandev"
  license "AGPL-3.0-only"
  version "0.82.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.82.0/kandev-macos-arm64.tar.gz"
      sha256 "09968195ef2fdf2fb304a00556bf62ef4adf342bf4ae71038746c0dd9a455668"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.82.0/kandev-macos-x64.tar.gz"
      sha256 "95286e45ef37085c325ba46da28dcfee28f78cf9a030dfdec2d62cfe60f85b4d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/kdlbs/kandev/releases/download/v0.82.0/kandev-linux-arm64.tar.gz"
      sha256 "dfc25a05917e066d7c7074cd80b68f773491ac476aa121be399088951c32c04d"
    else
      url "https://github.com/kdlbs/kandev/releases/download/v0.82.0/kandev-linux-x64.tar.gz"
      sha256 "c95995863ecf3772087118d3c8e992c94e7887a21cda0078c093290d8af3e015"
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
