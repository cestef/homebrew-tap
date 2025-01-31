class Braise < Formula
  desc "Run your tasks like a chef!"
  homepage "https://github.com/cestef/braise"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.2.3/braise-aarch64-apple-darwin.tar.xz"
      sha256 "85d0e644de4d2314ce8680923c24b0571a6e9be1e4ea2d74fec515a0187c6fad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.2.3/braise-x86_64-apple-darwin.tar.xz"
      sha256 "3d396074aad935f173f95b626930bb58a0100fc3cde171dad728900c51a4dbe1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.2.3/braise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8eb7e43e90be443387792d376d15ee70cb9563c92eae50f3c454e7d8b2b1ee98"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.2.3/braise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "50a9ca363f9217110a2c0db29d24a871e579e437d5b31862b1ff354a230d1da0"
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
    bin.install "braise" if OS.mac? && Hardware::CPU.arm?
    bin.install "braise" if OS.mac? && Hardware::CPU.intel?
    bin.install "braise" if OS.linux? && Hardware::CPU.arm?
    bin.install "braise" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
