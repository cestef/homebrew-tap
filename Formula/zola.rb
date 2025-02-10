class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.19.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getzola/zola/releases/download/v0.19.13/zola-aarch64-apple-darwin.tar.xz"
      sha256 "532f5934984bdd2d86807f188ff2c546acc3f4afa3936ed2f888b943421b2c00"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getzola/zola/releases/download/v0.19.13/zola-x86_64-apple-darwin.tar.xz"
      sha256 "306b971ce778db4d4d18751a7ace3f9e8eb8f6b98e88f366d22e5c960af8438e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getzola/zola/releases/download/v0.19.13/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2097416db3b3766255beae21168598ebf3574579cb11e83e1c17e75bbbc708d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getzola/zola/releases/download/v0.19.13/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fed6468ea00a9281cf2b5e29e27dec85772924bbedadb668a220877e0157bcf9"
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
