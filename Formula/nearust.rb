class Nearust < Formula
  desc "Fast detection of similar strings"
  homepage "https://github.com/yutanagano/nearust"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/nearust/releases/download/v0.4.0/nearust-aarch64-apple-darwin.tar.xz"
      sha256 "34868a47b06745b6d2bcb5ede881879dcec741320d772f789e678f9430e2a90e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/nearust/releases/download/v0.4.0/nearust-x86_64-apple-darwin.tar.xz"
      sha256 "3f703cbf0ce78bb38029a67614af4a6c03af84b09c17569770af2496c04bf4fb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/nearust/releases/download/v0.4.0/nearust-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "97107d30c479ec8245a9b1a015db931a081d9636025fc9d4de8450855e42169c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/nearust/releases/download/v0.4.0/nearust-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "75bc0bd3dd77e36ba1bcfc26bcaa7a64227866bf665e7ef7b26f8dd1756490d8"
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
