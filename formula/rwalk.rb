# typed: true
# frozen_string_literal: true

# This file was generated by Homebrew Releaser. DO NOT EDIT.
class Rwalk < Formula
  desc "Blazing fast web directory scanner written in rust"
  homepage "https://github.com/cestef/rwalk"
  url "https://github.com/cestef/rwalk/archive/refs/tags/v0.7.5.tar.gz"
  version "0.7.5"
  sha256 "1a1a1df396cb3fe22b5de12d2ccc17fb63f27d85f015b94094c4c83f942dbd36"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/cestef/rwalk/releases/download/v0.7.5/rwalk-0.7.5-darwin-amd64.tar.gz"
      sha256 "df1c2c636ec0e54a4d2007359e37e1c95df3bd24311471bdbd0229eda85a7a1d"
    end

    on_arm do
      url "https://github.com/cestef/rwalk/releases/download/v0.7.5/rwalk-0.7.5-darwin-arm64.tar.gz"
      sha256 "c365dd9c8ca59d4c92cd770a76a70ee52f843dc4640b5d865e9eec488b3fbeae"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cestef/rwalk/releases/download/v0.7.5/rwalk-0.7.5-linux-amd64.tar.gz"
      sha256 "abb4739e3a3a3e852bda68a4dee96e6a0c0f9a4894725ae1d3d4a919138c0d57"
    end

    on_arm do
      url "https://github.com/cestef/rwalk/releases/download/v0.7.5/rwalk-0.7.5-linux-arm64.tar.gz"
      sha256 "b90d2c7a12e94b9adb00169b4f0bc684f428befe50d8e8207737f202c8f16e94"
    end
  end

  def install
    bin.install "rwalk"
  end
end
