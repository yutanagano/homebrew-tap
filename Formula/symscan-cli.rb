class SymscanCli < Formula
  desc "Fast discovery of similar strings in bulk"
  homepage "https://github.com/yutanagano/symscan"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/v0.7.2/symscan-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3b7f84d2c5a97d2daa470681e9b4920ad13f70bbeff21cc7c4105655d21890ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/v0.7.2/symscan-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4cc8f9484ed78c4db68e5f52eda8dc0642f2ec3aa73ddeefee2029cfb9f2e39b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/symscan/releases/download/v0.7.2/symscan-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c74d0dd79d7122429d2fbe74589857c3a7d7356f957fa36300f342d621152d9d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/symscan/releases/download/v0.7.2/symscan-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bb19892efbf4e84374b3d6d23326c3ef9b1aed5d287b50b7c1d5578d9b45ef45"
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
