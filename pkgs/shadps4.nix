{ lib
, stdenv
, fetchFromGitHub
, llvmPackages_18
, cmake
, pkg-config
, git
, qt6
, alsa-lib
, libpulseaudio
, openal
, openssl
, zlib
, libedit
, udev
, libevdev
, SDL2
, jack2
, sndio
, vulkan-headers
, vulkan-utility-libraries
, vulkan-tools
, ffmpeg
, fmt
, glslang
, libxkbcommon
, wayland
, xorg
, sdl3
, stb
, wayland-protocols
, libpng
}: 
stdenv.mkDerivation {
  pname = "shadps4";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "shadps4-emu"; 
    repo = "shadPS4";
    rev = "9061028ce588037fa6f467cd2c0740d10ed725ed";
    hash = "sha256-XhfJx1sDFz+RwhwcBA8W6WV6y1rDDvpyQe3v3NaSu2I=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
      llvmPackages_18.clang
      cmake
      pkg-config
      git
      qt6.wrapQtAppsHook
  ];

  buildInputs = [
      alsa-lib
      libpulseaudio
      openal
      openssl
      zlib
      libedit
      udev
      libevdev
      SDL2
      jack2
      sndio
      qt6.qtbase
      qt6.qttools
      qt6.qtmultimedia

      vulkan-headers
      vulkan-utility-libraries
      vulkan-tools

      ffmpeg
      fmt
      glslang
      libxkbcommon
      wayland
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilkeysyms
      xorg.xcbutilwm
      sdl3
      stb
      qt6.qtwayland
      wayland-protocols
      libpng
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT_GUI" true)
    (lib.cmakeBool "ENABLE_UPDATER" false)
  ];

  cmakeBuildType = "RelWithDebugInfo";
  dontStrip = true;

  installPhase = ''
  runHook preInstall

  install -D -t $out/bin shadps4
  install -Dm644 $src/.github/shadps4.png $out/share/icons/hicolor/512x512/apps/net.shadps4.shadPS4.png
  install -Dm644 -t $out/share/applications $src/dist/net.shadps4.shadPS4.desktop
  install -Dm644 -t $out/share/metainfo $src/dist/net.shadps4.shadPS4.metainfo.xml

  runHook postInstall
  '';

}
