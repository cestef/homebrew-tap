class Braise < Formula
  desc "Run your tasks like a chef!"
  homepage "https://github.com/cestef/braise"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.2.4/braise-aarch64-apple-darwin.tar.xz"
      sha256 "bbed57fd8e9daaaff248a40ac3f4676c536d0641aa6545fc622d396befecdc14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.2.4/braise-x86_64-apple-darwin.tar.xz"
      sha256 "7d6c9fbdab70fd5e50ede27110e9b921aca8757b72af35ec44e49bb10d8f6b56"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.2.4/braise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "77c7ed1805bb7e3cb279d57bafbda16249327052e7fbd7aef6d38df371f56f6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.2.4/braise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4aab68fa554a8e46dd7f69ec32e37a62252d2ed7e415969deb7b5ab071f45a06"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {
      braise: [
        "br",
      ],
    },
    "aarch64-unknown-linux-gnu": {
      braise: [
        "br",
      ],
    },
    "x86_64-apple-darwin":       {
      braise: [
        "br",
      ],
    },
    "x86_64-pc-windows-gnu":     {
      "braise.exe": [
        "br.exe",
      ],
    },
    "x86_64-unknown-linux-gnu":  {
      braise: [
        "br",
      ],
    },
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
    bin.install "braise" if OS.mac? && Hardware::CPU.arm?
    bin.install "braise" if OS.mac? && Hardware::CPU.intel?
    bin.install "braise" if OS.linux? && Hardware::CPU.arm?
    bin.install "braise" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
