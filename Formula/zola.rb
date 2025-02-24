class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.20.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.20.5/zola-aarch64-apple-darwin.tar.xz"
      sha256 "20fb13bdd069ab4995a35e4b55eef6f24ae60bf238a4a8050ae7b98cbb0e6071"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.20.5/zola-x86_64-apple-darwin.tar.xz"
      sha256 "88bf6aad456b2c99502e8e93c47af6b97047b9deded50694a19bbfc66b171151"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.20.5/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3401f65cf47e2c61daece0e86eb1a887a97675a7bd235e818804f7b9457db5c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.20.5/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "93b7e2e7df17c8d2c007be57f742e7acd1a74d6eeb98a3e3490b61ec41ca30de"
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
