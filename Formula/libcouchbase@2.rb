class LibcouchbaseAT2 < Formula
  desc "C library for Couchbase"
  homepage "https://docs.couchbase.com/c-sdk/2.10/start-using-sdk.html"
  url "https://packages.couchbase.com/clients/c/libcouchbase-2.10.9.tar.gz"
  sha256 "6f6450121e0208005c17f7f4cdd9258a571bb22183f0bc08f11d75c207d55d0a"
  license "Apache-2.0"
  bottle do
    sha256 arm64_big_sur: "fc953052461b5fff2a327e017be7a69d03b5dc27ee7cc85aef35d688771059cc"
    sha256 big_sur:       "301e8a60feeae14d7edce86f2a414d0097553e837b07b5a414f1b871b33519c4"
    sha256 catalina:      "d3065af67b6c27379c674fadeca9a3a37eda0323d701769c34ab4aa5d5e1a345"
    sha256 mojave:        "b0fc35ac0a09d79476957fef601928fce6e9bc1abee8ec3522d59a389754fa39"
    sha256 high_sierra:   "4efb6194205ecbd2149ccda7631ca9f5257bcf8bc8ea00e89d50fbb7f7113da2"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DLCB_NO_TESTS=1",
                            "-DLCB_BUILD_LIBEVENT=ON",
                            "-DLCB_BUILD_LIBEV=ON",
                            "-DLCB_BUILD_LIBUV=ON"
      system "make", "install"
    end
  end

  test do
    assert_match "LCB_ECONNREFUSED",
      shell_output("#{bin}/cbc cat document_id -U couchbase://localhost:1 2>&1", 1).strip
  end
end
