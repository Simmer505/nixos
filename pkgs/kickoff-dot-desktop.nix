{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
    pname = "kickoff-dot-desktop";
    version = "0.1.0";

    src = fetchFromGitHub {
            owner = "j0ru";
            repo = "kickoff-dot-desktop";
            rev = "ba3e8788c7120c95c4ee963abf3904eb0736cb24";
            hash = "sha256-exMmqOkDKuyAEdda8gG/uF3+tnQzhJnOJK+sEtZbsZc=";
    };

    cargoHash = "sha256-z3apcltBKNovwo+yOHxvzn53PPefr2lEzkGst25fGsM=";

    meta = with lib; {
            description = "Smol program to read in relevant desktop files and print them in a kickoff compatible format";
            homepage = "https://github.com/j0ru/kickoff-dot-desktop";
            license = licenses.unlicense;
            maintainers = [];
    };
}


