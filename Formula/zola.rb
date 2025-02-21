class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.20.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.20.4/zola-aarch64-apple-darwin.tar.xz"
      sha256 "44cff503e9668bff7c814a2a5a15830993cbd124d09557c17e1bc23b07006277"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.20.4/zola-x86_64-apple-darwin.tar.xz"
      sha256 "5df8fd637b9a2707e2e8838cc30227f92e67bd2e3455b1c0aaf47ea7e04d1615"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.20.4/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b7dbc959eafd666f012e428297b1e8f059081ca3412087a10c60da4e2993ad51"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.20.4/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a2a5267130b26c8397f1be5958b9075923f03e17804a505938569e4ede6bd5e8"
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
