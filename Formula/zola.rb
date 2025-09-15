class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.20.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.20.13/zola-aarch64-apple-darwin.tar.xz"
      sha256 "3c85960df3a668fb4d72598a50f60bb8aef3dbd71bc5ea06b0c04764e6efc242"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.20.13/zola-x86_64-apple-darwin.tar.xz"
      sha256 "57b5536a6bda5fb936243a4e1443e56a128d919ed9eb1f9931720bdcbddc4e5b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.20.13/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e18820144e8ae19880561d4dc0a7751e563fb0ca6b17dd91d9a1de29e110e37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.20.13/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "29382ec643d63e299a69fb810fe2a6af23b084a4404bbde7dabf9381014cd0d9"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
