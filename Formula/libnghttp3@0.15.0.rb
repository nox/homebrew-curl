class Libnghttp3AT0150 < Formula
  desc "HTTP/3 C Library"
  homepage "https://nghttp2.org/nghttp3/"
  license "MIT"

  head do
    url "https://github.com/ngtcp2/nghttp3.git", tag: "v0.15.0"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", *std_configure_args, "--enable-lib-only"
    system "make", "-C", "lib"
    system "make", "-C", "lib", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nghttp3/nghttp3.h>
      #include <stdio.h>

      int main() {
        nghttp2_info *info = nghttp3_version(0);
        printf("%s", info->version_str);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnghttp3", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
