class Libngtcp2AT0191 < Formula
  desc "\"Call it TCP/2. One More Time.\""
  homepage "https://github.com/ngtcp2/ngtcp2/"
  license "MIT"

  head do
    url "https://github.com/ngtcp2/ngtcp2.git", tag: "v0.19.1"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl-quictls@3.0.10"
  depends_on "libnghttp3@0.15.0"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssl=#{Formula["openssl-quictls@3.0.10"].opt_prefix}
      --with-libnghttp3=#{Formula["libnghttp3@0.15.0"].opt_prefix}
    ]

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl-quictls@3.0.10"].opt_lib/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libnghttp3@0.15.0"].opt_lib/"pkgconfig"

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *std_configure_args, "--enable-lib-only"
    system "make"
    system "make", "install"
  end
end
