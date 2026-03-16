{
  description = "Nix flake for the Playwright CLI";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            pkgs = nixpkgs.legacyPackages.${system};
            inherit system;
          }
        );
    in
    {
      packages = forAllSystems (
        { pkgs, ... }:
        let
          versions = import ./versions.nix;
          playwright = pkgs.callPackage ./package.nix {
            inherit (versions) version srcHash npmDepsHash;
          };
        in
        {
          playwright-cli = playwright;
          default = playwright;
        }
      );

      apps = forAllSystems (
        { pkgs, ... }:
        let
          versions = import ./versions.nix;
          playwright = pkgs.callPackage ./package.nix {
            inherit (versions) version srcHash npmDepsHash;
          };
        in
        {
          playwright-cli = {
            type = "app";
            program = "${playwright}/bin/playwright-cli";
          };
          default = {
            type = "app";
            program = "${playwright}/bin/playwright-cli";
          };
        }
      );

      devShells = forAllSystems (
        { pkgs, ... }:
        let
          versions = import ./versions.nix;
          playwright = pkgs.callPackage ./package.nix {
            inherit (versions) version srcHash npmDepsHash;
          };
        in
        {
          default = pkgs.mkShell {
            packages = [ playwright ];
          };
        }
      );

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt-rfc-style);
    };
}
