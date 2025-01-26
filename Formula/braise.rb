class Braise < Formula
  desc "Run your tasks like a chef !"
  homepage "https://github.com/cestef/braise"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.1.11/braise-aarch64-apple-darwin.tar.xz"
      sha256 "18879e5b201bd702c0df3f87c075390f92d5209ab55c8a15757ef0112ad548d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.11/braise-x86_64-apple-darwin.tar.xz"
      sha256 "59f3272906dad8f5c3849698c0f5af3a27371a385af1d4ba658869f335a11ab8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.1.11/braise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "84a089b27430d8a8e10988304d34c47d7253d0c8f5d8e151b3fc2a2a2a032408"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.11/braise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ba6ab3a6f4c4f5382b2d47c09f46325c768910ff8203de8175ae4f11b0fd54df"
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
