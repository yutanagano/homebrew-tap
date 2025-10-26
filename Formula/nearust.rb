class Nearust < Formula
  desc "Fast detection of similar strings"
  homepage "https://github.com/yutanagano/nearust"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/nearust/releases/download/v0.5.1/nearust-aarch64-apple-darwin.tar.xz"
      sha256 "110d8b19f3bfd8c017f11dcb34c21bd423f0b71462fd1f332f57853aaafe9fa0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/nearust/releases/download/v0.5.1/nearust-x86_64-apple-darwin.tar.xz"
      sha256 "bb1d211f5ce8793c9ccec090a0377634f6a8d5ae92de6fe59a5493542ad98bbc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/nearust/releases/download/v0.5.1/nearust-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "51666ed2634b2f49892c18ac27b69e8b9e22667719a0f41c2c0a0735a639ae1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/nearust/releases/download/v0.5.1/nearust-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4b15ff29166338ee538135a4e9a4f10ccbc7c444063fe932411437dd8333d302"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "nearust" if OS.mac? && Hardware::CPU.arm?
    bin.install "nearust" if OS.mac? && Hardware::CPU.intel?
    bin.install "nearust" if OS.linux? && Hardware::CPU.arm?
    bin.install "nearust" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
