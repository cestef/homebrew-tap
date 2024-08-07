class Braise < Formula
  desc "Run your tasks like a chef !"
  homepage "https://github.com/cestef/braise"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.1.7/braise-aarch64-apple-darwin.tar.xz"
      sha256 "9c95afab280d4407cb5d5aeaff0d8af172f2145b626f68a945a5bc9fcc5fe175"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.7/braise-x86_64-apple-darwin.tar.xz"
      sha256 "c776a756f59e5212377fb1a39133300aa8455073df646215f1b220dde71976de"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.7/braise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "56be37e2942f03f45cf0c49cc30e3661210e5b6745d8dcff3600251271e992ad"
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
