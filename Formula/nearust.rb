class Nearust < Formula
  desc "Fast detection of similar strings"
  homepage "https://github.com/yutanagano/nearust"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/nearust/releases/download/v0.5.0/nearust-aarch64-apple-darwin.tar.xz"
      sha256 "49a1b7696a35c546f973841282affca931d7af1256e20492c7c5a20fc4316fd4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/nearust/releases/download/v0.5.0/nearust-x86_64-apple-darwin.tar.xz"
      sha256 "945a0baf6074889db0c6eb375c420127c84322630e84f0b0ba9f7972f2e0704a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/yutanagano/nearust/releases/download/v0.5.0/nearust-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "efc455e1e364e15486b825b4d6951371cf06cb62099bd6c353fb699c854d5781"
    end
    if Hardware::CPU.intel?
      url "https://github.com/yutanagano/nearust/releases/download/v0.5.0/nearust-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1a5021419730eddfeaa411cfee66fa1ef56ec8c5f07cfaf4d6d27b7af1d05548"
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
