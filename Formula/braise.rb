class Braise < Formula
  desc "Run your tasks like a chef !"
  homepage "https://github.com/cestef/braise"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.1.5/braise-aarch64-apple-darwin.tar.xz"
      sha256 "0e17504c0b0e625a3311fa2450ca37868808fd4912d2d3dc81150d3ec091c41a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.5/braise-x86_64-apple-darwin.tar.xz"
      sha256 "6b8408ff7a4331bff4bcd0d34fc8d736cba7064a2b96661f3701890444511852"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.5/braise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d575e5365d90ede1bac072556ce42ef321f3268dc7719f45f1a780cdebba941"
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
