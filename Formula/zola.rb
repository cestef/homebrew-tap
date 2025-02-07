class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.19.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.19.9/zola-aarch64-apple-darwin.tar.xz"
      sha256 "d3f88c482e2b24e484ced64ae33b4f7d8577db87a6d90964cc5eb49ed8322ed1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.19.9/zola-x86_64-apple-darwin.tar.xz"
      sha256 "ef45cfb655f5bfd7f3d6937edc6768e9ae0cf6395e99b687558c1c412b1afbc3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.19.9/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af73483fb4fdca9bb67aa272ee55691188819bec30e88f60d401f10a92e90be9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.19.9/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1904c43e3bc8a761e1756cb47bfe4611ce24969f2e458e8855d61b927cf4e616"
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
