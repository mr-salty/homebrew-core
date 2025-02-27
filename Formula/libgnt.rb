class Libgnt < Formula
  desc "NCurses toolkit for creating text-mode graphical user interfaces"
  homepage "https://keep.imfreedom.org/libgnt/libgnt"
  url "https://downloads.sourceforge.net/project/pidgin/libgnt/2.14.2/libgnt-2.14.2.tar.xz"
  sha256 "61cf74b14eef10868b2d892e975aa78614f094c8f4d30dfd1aaedf52e6120e75"
  license "GPL-2.0"

  livecheck do
    url "https://sourceforge.net/projects/pidgin/files/libgnt/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9f69a2025fb154ec282f75ea1adcfdaefcacc62d493c966b1febf8b52eac2f88"
    sha256 cellar: :any, big_sur:       "4f5d3a4eac1bc6ced4b77e166d17c69ae675aafab501a1c6a160d96fb4d16767"
    sha256 cellar: :any, catalina:      "97281ee7db978e4a605173bd5abf7fa88db1d641f374189f534db8072afa4e82"
    sha256 cellar: :any, mojave:        "066da1b998539c7f36e25b57606d20621ca02be456b708ae9e6b59b99eccb7e5"
  end

  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gnt/gnt.h>

      int main() {
          gnt_init();
          gnt_quit();

          return 0;
      }
    EOS

    flags = [
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
      "-I#{include}",
      "-L#{lib}",
      "-L#{Formula["glib"].opt_lib}",
      "-lgnt",
      "-lglib-2.0",
    ]
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end
