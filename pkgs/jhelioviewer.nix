{ lib
, stdenv
, jdk
, jre
, ant
, jogl
, libGL
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, stripJavaArchivesHook
, makeWrapper
, ...
}:
stdenv.mkDerivation {
    name = "JHelioviewer";

    src = fetchFromGitHub {
        owner = "Helioviewer-Project";
        repo = "JHelioviewer-SWHV";
        rev = "537b60bbf4c40e46b98d7a1c0167f3c943e73cd2";
        hash = "sha256-LBiywlXAgMifn6ov04CwEnfhSWskSzIy5Cs3NeL90Ts=";
    };

    nativeBuildInputs = [ 
        jdk
        ant
        stripJavaArchivesHook
        makeWrapper
        copyDesktopItems
    ];

    buildPhase = ''
        runHook preBuild
        ant
        runHook postBuild
    '';

    desktopItems = [
        (makeDesktopItem {
            name = "jhelioviewer";
            desktopName = "JHelioviewer";
            exec = "jhelioviewer";
            comment = "A visualization tool for solar physics data based on the JPEG 2000 image compression standard, and part of the open source ESA/NASA Helioviewer Project";
            icon = "hvLogo";
        })
    ];

    installPhase = ''
        runHook preInstall

        mkdir -p $out/share/java/
        mkdir -p $out/share/java/lib

        install -Dm644 JHelioviewer.jar $out/share/java/

        cp -r lib/* $out/share/java/lib/

        rm $out/share/java/lib/jogl/*.jar
        cp -v ${jogl}/share/java/jogl*.jar ${jogl}/share/java/glue*.jar $out/share/java/lib/jogl

        mkdir $out/bin
        makeWrapper ${jre}/bin/java $out/bin/jhelioviewer \
            --prefix LD_LIBRARY_PATH : ${libGL}/lib/ \
            --add-flags "-cp $out/share/java/JHelioviewer.jar" \
            --add-flags "--add-exports java.desktop/sun.awt=ALL-UNNAMED" \
            --add-flags "--add-exports java.desktop/sun.swing=ALL-UNNAMED" \
            --add-flags "org.helioviewer.jhv.JHelioviewer" 

        mkdir -p $out/share/icons

        cp -v docs/hvLogo.png $out/share/icons/

        runHook postInstall
    '';
}
