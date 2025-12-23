{
  description = "Competitive programming problemsetting toolchain in Haskell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
      hpkgs = pkgs.haskell.packages.ghc910.override {
        overrides = final: prev: {
          # todo
          hsqml = prev.hsqml.overrideAttrs (old: {
            dontWrapQtApps = true;
            propagatedBuildInputs= (old.propagatedBuildInputs or []) ++ [
              pkgs.qt5.qtbase
              pkgs.qt5.qtdeclarative
            ];
          });
        };
      };

      cpmonad = returnShellEnv:
        let
          cpmonad = hpkgs.developPackage {
            root = ./.;
            inherit returnShellEnv;
            modifier = pkgs.haskell.lib.compose.overrideCabal (old: {
              buildTools = (old.buildTools or []) ++ lib.optionals returnShellEnv
                [ hpkgs.cabal-install
                  hpkgs.ghcid
                  hpkgs.haskell-language-server
                ];

              doCheck = true;
              doHaddock = returnShellEnv;
              enableLibraryProfiling = returnShellEnv;
              enableExecutableProfiling = returnShellEnv;

              executableToolDepends = (old.executableToolDepends or []) ++ [
                pkgs.qt5.wrapQtAppsHook
              ];
              executablePkgconfigDepends = (old.executablePkgconfigDepends or []) ++ [
                pkgs.qt5.qtbase
                pkgs.qt5.qtdeclarative
                pkgs.qt5.qtquickcontrols
                pkgs.qt5.qtquickcontrols2
              ];
            });
          };
        in
        if !returnShellEnv then cpmonad else cpmonad.overrideAttrs (old: {
          shellHook = (old.shellHook or "") + "\n" + ''
            length=''${#qtWrapperArgs[@]}
            for ((n = 0; n < length; n += 1))
            do
              case "''${qtWrapperArgs[n]}" in
                --prefix)
                  declare var="''${qtWrapperArgs[n + 1]}"
                  declare sep="''${qtWrapperArgs[n + 2]}"
                  declare cur="''${!var}"
                  declare "$var=''${qtWrapperArgs[n + 3]}''${cur:+$sep$cur}"
                  export "$var"
                ;;
              esac
            done
          '';
        });
    in
    {
      packages.${system} = {
        default = cpmonad false;
        inherit hpkgs pkgs;
      };
      devShells.${system} = {
        default = cpmonad true;
      };
    };
}
