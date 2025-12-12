class SymscanCli < Formula
  desc "Fast discovery of similar strings in bulk"
  homepage "https://github.com/yutanagano/symscan"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/v0.7.1/symscan-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5f7db7fe25125c3702f0c314906aced3ae5afaccdf045d31537f88f65b43b67f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/v0.7.1/symscan-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c52cc5da56d81ce9c3a46bcbee7a984bc496199e112b61036276a574ebd8164f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/v0.7.1/symscan-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5017fc58478e9d49dd63c256416b168ee1a91765a4909feac791284c86ad554d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/v0.7.1/symscan-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "517f170b0278e1559fb4690f44a7e9f3ed0d039c5f4c49716365016034e10d42"
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
    bin.install "symscan-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "symscan-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "symscan-cli" if OS.linux? && Hardware::CPU.arm?
    bin.install "symscan-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
