class Voxcut < Formula
  include Language::Python::Virtualenv

  desc "Audio editing TUI: cut fragments, isolate voices with SAM-Audio (MLX)"
  homepage "https://github.com/nullhtp/voxcut"
  url "https://files.pythonhosted.org/packages/source/v/voxcut/voxcut-0.1.0.tar.gz"
  sha256 "539a326293f37ca747708271c294bf4b616882118de6509f5a43776871ca3a67"
  license "MIT"

  depends_on "python@3.13"
  depends_on "ffmpeg"
  depends_on :macos

  def install
    virtualenv_create(libexec, "python3.13")

    # Create wrapper scripts
    (bin/"voxcut").write <<~SH
      #!/bin/bash
      exec "#{libexec}/bin/voxcut" "$@"
    SH
    (bin/"voxcut-separate").write <<~SH
      #!/bin/bash
      exec "#{libexec}/bin/voxcut-separate" "$@"
    SH
  end

  def post_install
    system libexec/"bin/python", "-m", "pip", "install", "voxcut==#{version}"
  end

  def caveats
    <<~EOS
      After install, run once to fetch Python dependencies:
        #{libexec}/bin/python -m pip install voxcut==#{version}

      On first run, voxcut downloads SAM-Audio model weights (~500 MB).
    EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/voxcut --help")
  end
end
