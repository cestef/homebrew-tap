class Poof < Formula
  desc "Drop and catch files over iroh using a simple cli."
  homepage "https://github.com/cestef/poof"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/poof/releases/download/v0.1.0/poof-aarch64-apple-darwin.tar.xz"
      sha256 "3dfba746b660e808aadc6d5137ded9faa1a95bb0e137b90d3955c647365a869c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/poof/releases/download/v0.1.0/poof-x86_64-apple-darwin.tar.xz"
      sha256 "811af55d4575ab4b8af88dc8459cb11eb05d5e5e3a7e49f582c026137ca897bb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cestef/poof/releases/download/v0.1.0/poof-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1755ed099a1a85445e9dff23373e8f3f566ef9f66bcdd1003b704f154ed6474f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cestef/poof/releases/download/v0.1.0/poof-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dfb1865439dffd29dee04acc007c91813a1acafb0e56e3601f99ece4957f5382"
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
    bin.install "poof" if OS.mac? && Hardware::CPU.arm?
    bin.install "poof" if OS.mac? && Hardware::CPU.intel?
    bin.install "poof" if OS.linux? && Hardware::CPU.arm?
    bin.install "poof" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
