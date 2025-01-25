class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.19.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getzola/zola/releases/download/v0.19.5/zola-aarch64-apple-darwin.tar.xz"
      sha256 "45aea80e9c97c71e6c3d48605131b8e6082a9b166d6e14f853009a26a2157d24"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getzola/zola/releases/download/v0.19.5/zola-x86_64-apple-darwin.tar.xz"
      sha256 "a6d336fbb87280a42873118ecb81b253dfd27601339d70b6c7fb22b9272fde48"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getzola/zola/releases/download/v0.19.5/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b692fda242df3bdc67c376ebb0b0a80bfa5251a9edc6dbba3ee390633159a361"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getzola/zola/releases/download/v0.19.5/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e470d2ec1ee1dffc308b44d1239c82965c77640003590299815d711bb6180e27"
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
