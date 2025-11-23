class Nearust < Formula
  desc "Fast detection of similar strings"
  homepage "https://github.com/yutanagano/nearust"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/nearust/releases/download/v0.6.0/nearust-aarch64-apple-darwin.tar.xz"
      sha256 "85f5ac895203b09b5415559ea65a9c999d62939a6b5cadae9cfe2d3536b13453"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/nearust/releases/download/v0.6.0/nearust-x86_64-apple-darwin.tar.xz"
      sha256 "13992e50cf8cd6129d737d1768f6e25483452deb2ecbd7feb87a15c599a6a658"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/nearust/releases/download/v0.6.0/nearust-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5da21581c9a8f1c2c8bb6bdcc1204668e3dea1579158f432acf71ad750530d87"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/nearust/releases/download/v0.6.0/nearust-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "85a861d8de21131a2f00eb04d122970a01e30008c0f2ff12c6852589c0d5ae59"
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
