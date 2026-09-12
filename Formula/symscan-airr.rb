class SymscanAirr < Formula
  desc "Fast similarity measurement between adaptive immune receptor repertoire data, powered by symscan."
  homepage "https://github.com/yutanagano/symscan"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/symscan-airr/v0.1.0/symscan-airr-aarch64-apple-darwin.tar.xz"
      sha256 "03fd4ecc9e28f77a6f608133b666d3962caf89095e3e6304e86a0d3beea88588"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/symscan-airr/v0.1.0/symscan-airr-x86_64-apple-darwin.tar.xz"
      sha256 "e1107239c2cee5a05435cee4b5dc62afff156b0aacf1cfbab93bed8586b13c7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/symscan-airr/v0.1.0/symscan-airr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5f3ec8c06e43006115399c087067624942fa9d8b24b5af293e7fc5c7695d8434"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/symscan-airr/v0.1.0/symscan-airr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0a4ff031b74f0a8708bc49831628b61db6d31c5db064b8e872a1a50e11e6db9b"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "symscan-airr"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "symscan-airr"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "symscan-airr"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "symscan-airr"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
