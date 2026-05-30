class SymscanCli < Formula
  desc "Fast discovery of similar strings in bulk"
  homepage "https://github.com/yutanagano/symscan"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.1/symscan-cli-aarch64-apple-darwin.tar.xz"
      sha256 "056b9d6e007042c18f97da1190c8fa6d4bb1498228432b57b6889bf7cf629b3d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.1/symscan-cli-x86_64-apple-darwin.tar.xz"
      sha256 "81dd107624ef72f72640ed95bf455ce03044519f9f11c7698babec3ae57368b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.1/symscan-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8fdd0d45e18c74fc250247e60ed7fb8f1adc6da80a6e54b1ed8ab415c18deba2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/v0.8.1/symscan-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b2d60bbb6cf43b0559f4512df183b2680d09175434969624fbbfdcdfdf4f98a5"
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
