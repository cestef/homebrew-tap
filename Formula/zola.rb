class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.19.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.19.8/zola-aarch64-apple-darwin.tar.xz"
      sha256 "a98e2a20fb2f4bd9f9b85f5262ef008cd313cda17020050ce2100d5c75728fab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.19.8/zola-x86_64-apple-darwin.tar.xz"
      sha256 "d76ec729f987aea8ef537d361c262e989ebb3f1e81e4e9011a752a17d00c5302"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.19.8/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e28fc6edfed21d3d13bbdcef6230d0ead749120e2a1772bb1d24bf2c4279d06a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.19.8/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8861ce3babd5c249c6a178f79bb1b1e2c7dea0595497268b099d6cfd01dd1309"
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
