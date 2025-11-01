{ lib, stdenv, fetchFromGitHub, makeWrapper, gcc, gnumake }:

stdenv.mkDerivation rec {
  pname = "ghostc";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "Slowbro213";
    repo  = "ghostty-ghost-c";
    rev   = "39ca2eac9d72b6ecb7421c8085b326934a761d6c";
    sha256 = "sha256-ExOGjRqQmNOb+BRsQIvIxVkMbk+la87+DRTOaiuGmC8=";
  };

  nativeBuildInputs = [ gnumake gcc ];

  buildPhase = ''
    echo "=== buildPhase: running make ==="
    make
  '';

  installPhase = ''
    echo "=== installPhase: installing binary ==="
    mkdir -p $out/bin
    cp ./bin/ghostc $out/bin/ghostc
    chmod +x $out/bin/ghostc
  '';

  meta = with lib; {
    description = "Ghost C animation binary (built from Slowbro213/ghostty-ghost-c)";
    license = licenses.mit;
  };
}

