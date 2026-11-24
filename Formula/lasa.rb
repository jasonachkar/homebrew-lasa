class Lasa < Formula
  desc "Scoped read-only Linux attack surface analyzer"
  homepage "https://github.com/jasonachkar/lasa"
  version "0.1.1"
  license "MIT"
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/jasonachkar/lasa/releases/download/v0.1.1/lasa-0.1.1-linux-amd64.tar.gz"
      sha256 "201f08152d34e1c1718eb7135b1f059d8844d88466491cba4fa8a4d5684a794a"
    end
    on_arm do
      url "https://github.com/jasonachkar/lasa/releases/download/v0.1.1/lasa-0.1.1-linux-arm64.tar.gz"
      sha256 "1be7c0cf0c841911405e2ff18db393280e0485c065cb25095185dae9c3b4def2"
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
