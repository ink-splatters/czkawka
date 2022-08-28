{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-flake.url = "github:srid/treefmt-flake";
  };

  outputs = { self, flake-parts, nixpkgs, treefmt-flake, ... }:
    flake-parts.lib.mkFlake { inherit self; } {

      imports = [ treefmt-flake.flakeModule ];
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = { config, self', inputs', pkgs, system, ... }: {

        # Provided by treefmt-flake.flakeModule
        treefmt.formatters = {
          inherit (pkgs) nixpkgs-fmt rustfmt shfmt;

          inherit (pkgs.python3Packages) black;
          inherit (pkgs.nodePackages) prettier;


        };

        devShells = {

          default = pkgs.mkShell {
            buildInputs = (with pkgs; [
              direnv
              rustc
              cargo
              clippy
              grcov
              rustc.llvmPackages.llvm

            ] ++ config.treefmt.buildInputs);


            shellHook = ''
              export PS1="\n\[\033[1;32m\][nix-shell:\w]\$\[\033[0m\] "
              direnv allow .
            '';


          };

        };

      };
    };

}


