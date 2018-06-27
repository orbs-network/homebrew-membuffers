class Membufc < Formula
  desc "Compiler for .proto schemas for MemBuffers serialization library"
  homepage "https://github.com/orbs-network/membuffers"

  # Source code archive. Each tagged release will have one
  url "https://github.com/orbs-network/membuffers/archive/0.0.1.tar.gz"
  sha256 "b854e29c0f0f02eb696c4918569450c64aae70aae3b350b39f3873e38df170b1"
  head "https://github.com/orbs-network/membuffers"
  
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/orbs-network/membuffers/go/membufc"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/orbs-network/membuffers/go/membufc
    bin_path.install Dir["*"]
    
    cd bin_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing
      # global variable
      system "go", "get", "-u", "github.com/gobuffalo/packr/..."
      system "packr", "build", "-o", bin/"membufc", "."
    end
  end

  # Homebrew requires tests.
  test do
    # "2>&1" redirects standard error to stdout. The "2" at the end means "the
    # exit code should be 2".
    assert_match "membufc 0.0.1", shell_output("#{bin}/membufc --version 2>&1", 2)
  end
end
