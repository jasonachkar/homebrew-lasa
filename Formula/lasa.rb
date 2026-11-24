class Lasa < Formula
  desc "Scoped read-only Linux attack surface analyzer"
  homepage "https://github.com/jasonachkar/lasa"
  version "0.1.2"
  license "MIT"
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/jasonachkar/lasa/releases/download/v0.1.2/lasa-0.1.2-linux-amd64.tar.gz"
      sha256 "871a96774f33f69e5d06f440b1bc53d1a1cd9c9084ec0a8cb6efb168fa2f4785"
    end
    on_arm do
      url "https://github.com/jasonachkar/lasa/releases/download/v0.1.2/lasa-0.1.2-linux-arm64.tar.gz"
      sha256 "015a8c31e4dfa55cf68e8e9be941ad47e14b2614c1a3300aac7ee9a4a8788c86"
    end
  end

  def install
    bin.install "bin/lasa"
    doc.install Dir["share/doc/lasa/*"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lasa version").strip
    system bin/"lasa", "rules", "list"
  end
end
