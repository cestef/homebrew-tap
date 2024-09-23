class Braise < Formula
  desc "Run your tasks like a chef !"
  homepage "https://github.com/cestef/braise"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/braise/releases/download/v0.1.9/braise-aarch64-apple-darwin.tar.xz"
      sha256 "7800875b6fcb4fb0a733c19023a74fe01cec3deb11fe90b3acf209ae3f0e0ce5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.9/braise-x86_64-apple-darwin.tar.xz"
      sha256 "3efc69b52da5a130ddbdce6da3741d43af2afe1103900c71da7942c0d1aafbc6"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/cestef/braise/releases/download/v0.1.9/braise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "eb86f1e0d91ecc5eb1c5aee255d8c19c54c8142f6fdb70b922ef6fa82da2c48a"
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
