class Gimage < Formula
  desc "AI-powered image generation and processing CLI"
  homepage "https://github.com/chadneal/gimage"
  url "https://github.com/chadneal/gimage/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a05a872949055a75f0ecc84a173723b058a70f852f6038f3fb036895994b9743"
  license "MIT"
  head "https://github.com/chadneal/gimage.git", branch: "main"

  depends_on "go" => :build

  def install
    # Build the binary
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/chadneal/gimage/internal/cli.version=#{version}"), "./cmd/gimage"

    # Generate shell completions
    generate_completions_from_executable(bin/"gimage", "completion")
  end

  def caveats
    <<~EOS
      Before using gimage, set up your API credentials:
        $ gimage auth gemini    # For Gemini API (free tier available)
        $ gimage auth vertex    # For Vertex AI

      Get your Gemini API key from:
        https://aistudio.google.com/app/apikey

      Configuration is stored in:
        ~/.gimage/config.md
    EOS
  end

  test do
    # Test version output
    assert_match version.to_s, shell_output("#{bin}/gimage --version")

    # Test help output
    assert_match "AI-powered image generation", shell_output("#{bin}/gimage --help")

    # Verify subcommands exist
    help_output = shell_output("#{bin}/gimage --help")
    assert_match "generate", help_output
    assert_match "resize", help_output
    assert_match "crop", help_output
    assert_match "compress", help_output
    assert_match "convert", help_output
  end
end
