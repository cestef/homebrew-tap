class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.19.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.19.7/zola-aarch64-apple-darwin.tar.xz"
      sha256 "6c4531664b33d6e8033947337d827c37f1410171722bd24bb0dce218192514a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.19.7/zola-x86_64-apple-darwin.tar.xz"
      sha256 "9890212f151cc0b244b8fc008eb2e516c1715d98dcdede543e59b8833b625372"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.19.7/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8be2f44b33374307f2cf5edd01b1303e3b5cb432c7da23dee1e3a505c2e076fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.19.7/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d38ccd67d19536f1201c3d5199203686bda4727652a84195e6cb859e5fb3bf20"
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
