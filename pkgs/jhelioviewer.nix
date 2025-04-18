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
        rev = "c1affb8a820fb2785d7598a59dad3691bf42298c";
        hash = "sha256-CGpWPKsGQsX+3aaqws351hy2xCST/x+Md+dRBov1vog=";
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

        cp -rv lib/* $out/share/java/lib/

        rm $out/share/java/lib/jogl/*.jar
        cp -v ${jogl}/share/java/jogl*.jar ${jogl}/share/java/glue*.jar $out/share/java/lib/jogl

        mkdir $out/bin
        makeWrapper ${jre}/bin/java $out/bin/jhelioviewer \
            --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]} \
            --add-flags "-cp $out/share/java/JHelioviewer.jar" \
            --add-flags "--add-exports java.desktop/sun.awt=ALL-UNNAMED" \
            --add-flags "--add-exports java.desktop/sun.swing=ALL-UNNAMED" \
            --add-flags "org.helioviewer.jhv.JHelioviewer" 

        mkdir -p $out/share/icons

        cp -v docs/hvLogo.png $out/share/icons/

        runHook postInstall
    '';
}
