class Braise < Formula
  desc "Run your tasks like a chef !"
  homepage "https://github.com/cestef/braise"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.1.2/braise-aarch64-apple-darwin.tar.xz"
      sha256 "0c6e966c2d7c51fc03e06d49c32b559865182b10e171ef9731290c52e2346ed4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.2/braise-x86_64-apple-darwin.tar.xz"
      sha256 "6d094470c7d745e13839f45b522b3bc1207336cfea4fa5d9e0d3dd9f0b762119"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.2/braise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e790d6974562e401a78035242114b9ccbb912040e79e3292089cb6978e2441ab"
    end
  end

  BINARY_ALIASES = {"aarch64-apple-darwin": {"braise": ["br"]}, "x86_64-apple-darwin": {"braise": ["br"]}, "x86_64-pc-windows-gnu": {"braise.exe": ["br.exe"]}, "x86_64-unknown-linux-gnu": {"braise": ["br"]}}

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "braise"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "braise"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "braise"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
