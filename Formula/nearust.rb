class Nearust < Formula
  desc "Fast detection of similar strings"
  homepage "https://github.com/yutanagano/nearust"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/nearust/releases/download/v0.6.1/nearust-aarch64-apple-darwin.tar.xz"
      sha256 "cbdfb417dcb0791d1d03297ebc5b65a71af6b321e9c6506db9f234954e141e00"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/nearust/releases/download/v0.6.1/nearust-x86_64-apple-darwin.tar.xz"
      sha256 "ae2031cd9c748164d33337c21f5e6141a36ff410f69f930cadb4b9208c863432"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/nearust/releases/download/v0.6.1/nearust-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "244fbd27c5e9a76f3d5ae1331264dd7f234be7357bcdefc4eab67b18b8478861"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/nearust/releases/download/v0.6.1/nearust-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "efce134c3a709a7ee1dc68113add04179b0a1cbe076845a8bbc4a07fb2391d9c"
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
