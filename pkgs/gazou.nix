{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, tesseract4
, leptonica
, libsForQt5
}: 
stdenv.mkDerivation {
  name = "gazou";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "kamui-fin";
    repo = "gazou";
    rev = "7dd023fc78566f2911250f4b8550b0a33a943bb3";
    hash = "sha256-6auc5i6b7r4knzen4TCq2mTdbiv+qCD0mWE3LNyh2J4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    pkg-config
    tesseract4
    leptonica
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtdeclarative
  ];

  cmakeFlags = [
    "-DGUI=OFF"
  ];

  dontWrapQtApps = true;

}
