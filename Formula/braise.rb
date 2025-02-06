class Braise < Formula
  desc "Run your tasks like a chef!"
  homepage "https://github.com/cestef/braise"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.2.5/braise-aarch64-apple-darwin.tar.xz"
      sha256 "a487c8e49ff6e4cf4f157af4c7d79274ae1d507ade0b5c17397aa1292c7105f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.2.5/braise-x86_64-apple-darwin.tar.xz"
      sha256 "668646126434da0480b35d7c0fbd4d45d2d8aad7cf04ff4465e16c0df73e8a00"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.2.5/braise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0b51ad4bcb129f23b6f44a902a7a722bf0fba7e8e25859e7bdd91966c7aff0c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.2.5/braise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "21b4824fb6690c3c35bcf3e59a79b2a3b91a17d8e55b3554493b793bd7a4251a"
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
