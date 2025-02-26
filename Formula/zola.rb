class Zola < Formula
  desc "A fast static site generator with everything built-in"
  homepage "https://www.getzola.org"
  version "0.20.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.20.6/zola-aarch64-apple-darwin.tar.xz"
      sha256 "3e582fef715ec3053208119c6b867984edf4556f2ac0103778ab9fe4e30689f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.20.6/zola-x86_64-apple-darwin.tar.xz"
      sha256 "f4989edd07701e79ed72f6a64140fc3ed7ef0f9a419bd0c7f21233411f37fc8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/zola/releases/download/v0.20.6/zola-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c98dd2dc24e1b0e8363cc99463ef69dee61d3ec149b621331905d829b602b0c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/zola/releases/download/v0.20.6/zola-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1c9824261ab3222df44268de45400de301f3c646d47afe602fe391f1f60520dc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
