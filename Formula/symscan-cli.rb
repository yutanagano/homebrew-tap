class SymscanCli < Formula
  desc "Fast discovery of similar strings in bulk"
  homepage "https://github.com/yutanagano/symscan"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.3/symscan-cli-aarch64-apple-darwin.tar.xz"
      sha256 "07b03c6408569d6b4b98c8fccdc005a5d198125f2a65ff04dd1376ad9b862aa4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.3/symscan-cli-x86_64-apple-darwin.tar.xz"
      sha256 "02773b3bd38ff9ba77c83fbcfbb408afec23c3c6409ca42f1df1e010ddeaa04c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.3/symscan-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ccb4acfeee75b654eb71de99f7731b15a4d537ca661c0bc08b2d2c5f79f2ea0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.3/symscan-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4b07a0b68c864640ffc5d0e6ee5e4d6f619da1f3df145edf396d60bab9627df2"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
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
    bin.install "symscan" if OS.mac? && Hardware::CPU.arm?
    bin.install "symscan" if OS.mac? && Hardware::CPU.intel?
    bin.install "symscan" if OS.linux? && Hardware::CPU.arm?
    bin.install "symscan" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
