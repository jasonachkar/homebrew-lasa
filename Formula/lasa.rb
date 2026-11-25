class Lasa < Formula
  desc "Scoped read-only Linux attack surface analyzer"
  homepage "https://github.com/jasonachkar/lasa"
  version "0.2.2"
  license "MIT"
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/jasonachkar/lasa/releases/download/v0.2.2/lasa-0.2.2-linux-amd64.tar.gz"
      sha256 "fe2c16c270fcb875900b852ea851f5a7aa14df62b95d3c63b68d03694eb58207"
    end
    on_arm do
      url "https://github.com/jasonachkar/lasa/releases/download/v0.2.2/lasa-0.2.2-linux-arm64.tar.gz"
      sha256 "db0c3cfdb6653a358e1b2d4a72383be9dc27c358cb240fedb2995cb538a87a18"
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
