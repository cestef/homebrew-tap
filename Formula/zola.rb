class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.19.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.19.14/zola-aarch64-apple-darwin.tar.xz"
      sha256 "a54f93bfb779596ceac3c891fa0385ea1ef0641280bc1f22d6af5e30d89b22c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.19.14/zola-x86_64-apple-darwin.tar.xz"
      sha256 "d0a1d7dbb9872cdb140a9b8e36eb265f201df528eb367308ae64a1b4190c6194"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.19.14/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "68e67a4ddb592700ff2310c7e3fd5530bc4199b88ff5cd6f50bd1cbca6fe4a45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.19.14/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cb7272682319b322864d53f80af18c64c58fa9b2f727ddec20197d0bea0b306e"
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
