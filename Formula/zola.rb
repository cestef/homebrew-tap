class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.20.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.20.2/zola-aarch64-apple-darwin.tar.xz"
      sha256 "3a9b360ef2a31373fa8bb8e6f6fcac4afd6cab84f1edc1c6313ee3fe849c9a36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.20.2/zola-x86_64-apple-darwin.tar.xz"
      sha256 "84b66fe4de7afe869f1de2e14c891c7319adc251f3741f2fe800da639910fcc0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.20.2/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9617304971ae236d561211de0ebfc378a41c00380ad73984ce352857c1a78cc6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.20.2/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "088da99fcdc51eb5db9ff4899af64e6c96fa17ee17eb6ed81be2136a1ea3d5c1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "zola" if OS.mac? && Hardware::CPU.arm?
    bin.install "zola" if OS.mac? && Hardware::CPU.intel?
    bin.install "zola" if OS.linux? && Hardware::CPU.arm?
    bin.install "zola" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
