class Punch < Formula
  desc "Simple and fast peer-to-peer tunneling tool"
  homepage "https://github.com/cestef/punch"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/punch/releases/download/v0.1.0/punch-aarch64-apple-darwin.tar.xz"
      sha256 "0a3f522a696f8bfdee0e80ffe13e9dc41ab1371f17593d2679db33d01e7520ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/punch/releases/download/v0.1.0/punch-x86_64-apple-darwin.tar.xz"
      sha256 "4859931676ce03977ebcd1cb49c20ec141f21a5371cb0b63a97bcd1d982291f0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/punch/releases/download/v0.1.0/punch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "45b65df100b88908fb821854401dfcbc17f6fac3ec67b276e0373fbed995a8a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/punch/releases/download/v0.1.0/punch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "adb4e3d988a616d16751ca56979f3e7c855bbc923fde0a7df341679cacae78f4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
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
    bin.install "punch" if OS.mac? && Hardware::CPU.arm?
    bin.install "punch" if OS.mac? && Hardware::CPU.intel?
    bin.install "punch" if OS.linux? && Hardware::CPU.arm?
    bin.install "punch" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
