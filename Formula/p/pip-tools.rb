class PipTools < Formula
  include Language::Python::Virtualenv

  desc "Locking and sync for Pip requirements files"
  homepage "https://pip-tools.readthedocs.io"
  url "https://files.pythonhosted.org/packages/fd/01/f0055058a86a888f32ac794fa68d5a25c2d2f7a3e8181474b711faaa2145/pip-tools-7.3.0.tar.gz"
  sha256 "8e9c99127fe024c025b46a0b2d15c7bd47f18f33226cf7330d35493663fc1d1d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "785fe8509498f43d1fdfaec473198c8ed0e286c99df42dde019a95085801e7f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf4003d5fdce924f99cab63dff30494d56d1ced13548a51fd600fc162cad2fc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2eb55dac623a6bc8084c2e56335f21b36fa22c2ffe1895807b88b5f60979d0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d712e87d98f33af720bc70c3a02592c39c3532303cf2b5efdbd9cc8c50d033f"
    sha256 cellar: :any_skip_relocation, ventura:        "ebf3368975fcba359e47046d82953a50349b6372dc628261ac5c184037aeef9f"
    sha256 cellar: :any_skip_relocation, monterey:       "394a5815103f74ffdb131ad6ac1f9f858be02d4186da98c5d3361bf6a7f9d6fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b41590d76f7328b8e02e23052faf2f9ec31bee96f800e7b3a2c1147eadb539da"
  end

  depends_on "python@3.12"

  resource "build" do
    url "https://files.pythonhosted.org/packages/98/e3/83a89a9d338317f05a68c86a2bbc9af61235bc55a0c6a749d37598fb2af1/build-1.0.3.tar.gz"
    sha256 "538aab1b64f9828977f84bc63ae570b060a8ed1be419e7870b8b4fc5e6ea553b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/25/c1/374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64c/pyproject_hooks-1.0.0.tar.gz"
    sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
  end

  def install
    virtualenv_install_with_resources

    %w[pip-compile pip-sync].each do |script|
      generate_completions_from_executable(bin/script, shells: [:fish, :zsh], shell_parameter_format: :click)
    end
  end

  test do
    (testpath/"requirements.in").write <<~EOS
      pip-tools
      typing-extensions
    EOS

    compiled = shell_output("#{bin}/pip-compile requirements.in -q -o -")
    assert_match "This file is autogenerated by pip-compile", compiled
    assert_match "# via pip-tools", compiled
  end
end
