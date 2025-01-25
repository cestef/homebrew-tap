class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.19.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.19.6/zola-aarch64-apple-darwin.tar.xz"
      sha256 "1bae119e9da59fb2f417f471d5dfc321ca9f05b60dc86ab0742c01ce8edae651"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.19.6/zola-x86_64-apple-darwin.tar.xz"
      sha256 "8fda2eb16e5f8f95829cce781df8b28b50269530aafbed123508108ae1c1fdbc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.19.6/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a254d7497d06a519541f2d28fd982f8d24166c590f83ee4cb63cdf86272de44f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.19.6/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ed729e099792a44c66737f18b40b98e78967c4415a64c18641271e940dd89f4a"
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
