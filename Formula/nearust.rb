class Nearust < Formula
  desc "a minimal CLI utility for fast detection of similar strings"
  homepage "https://github.com/yutanagano/nearust"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/nearust/releases/download/v0.3.0/nearust-aarch64-apple-darwin.tar.xz"
      sha256 "87cef15174216bf113775aef92192329e5da831feed1cabd6572962172ea3aea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/nearust/releases/download/v0.3.0/nearust-x86_64-apple-darwin.tar.xz"
      sha256 "fd8534583113dbb36429053c62323f7af35855118274f2bc0045b448b45dc3c9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/yutanagano/nearust/releases/download/v0.3.0/nearust-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ab1c0279b822d433866bd4dc2826006b971faf84b02314f25b3e6dcab992e30d"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
