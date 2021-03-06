class Membufc < Formula
  desc "Compiler for .proto schemas for MemBuffers serialization library"
  homepage "https://github.com/orbs-network/membuffers"

  # Source code archive. Each tagged release will have one
  url "https://github.com/orbs-network/membuffers/archive/0.0.18.tar.gz"
  sha256 "ac526c098aeb4fc11f682deac3ba3a02f2a1514cf701d0db79a6f6d175658574"
  head "https://github.com/orbs-network/membuffers"
  
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/orbs-network/membuffers"
    bin_path.install Dir["*"]
    
    cd bin_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing
      # global variable
      system "go", "get", "./go/..."
      system "go", "get", "-u", "github.com/gobuffalo/packr/..."
      system buildpath/"bin/packr", "build", "-o", bin/"membufc", "./go/membufc"
      #system "go", "build", "-o", bin/"membufc", "./go/membufc"
    end
  end

  # Homebrew requires tests.
  test do
    # "2>&1" redirects standard error to stdout. The "2" at the end means "the
    # exit code should be 2".
    assert_match "membufc 0.0.18", shell_output("#{bin}/membufc --version 2>&1", 2)
  end
end
