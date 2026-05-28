class SymscanCli < Formula
  desc "Fast discovery of similar strings in bulk"
  homepage "https://github.com/yutanagano/symscan"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.0/symscan-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ed8616fa198272b2ab048f19ce5b8f38c8040d436e6928d4b62f91a361d83712"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.0/symscan-cli-x86_64-apple-darwin.tar.xz"
      sha256 "fc689d7592626aeca1a291835d1ef5fc7aa3447873daf55d87b9a943b46a9a7f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.0/symscan-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "834887c0869b2a2e3398572badaba99fad54b4be1a65ae6436b1c01bf35cdf8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.0/symscan-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4abbad25206af5ad050c02d51b0df158e001767f1f91b91b21ca4587b59da4a7"
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
