class Braise < Formula
  desc "Run your tasks like a chef !"
  homepage "https://github.com/cestef/braise"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.1.8/braise-aarch64-apple-darwin.tar.xz"
      sha256 "527e925fa8b1641912fd5f4902c3b1d6e261406ac7bca04df97490b33fb8fdad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.8/braise-x86_64-apple-darwin.tar.xz"
      sha256 "6496fc05752809558d91bef2a7e62df4e9129dc410521670852707a005efd69b"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.8/braise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "66dc7024e0db9a9fb98dd34f0c015926e02b6d676528509d97cf03e4f7ff78ad"
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
