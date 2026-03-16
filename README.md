# Playwright CLI

This is a Nix Flake for the [Playwright](https://playwright.dev) CLI tool (`@playwright/cli`).

## Contents

- [Usage](#usage)
- [Use this flake in your project](#use-this-flake-in-your-project)
- [Supported platforms](#supported-platforms)
- [Updating](#updating)

## Usage

Run directly from GitHub without cloning:

```bash
nix run github:kennethhoff/playwright-cli-flake#playwright-cli
```

Run from this repo:

```bash
nix run .
```

Build the package:

```bash
nix build .#playwright-cli
```

Add to a temporary shell:

```bash
nix shell . --command playwright-cli --help
```

## Use this flake in your project

Add this flake as an input and include the package in your dev shell.

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    playwright-cli.url = "github:kennethhoff/playwright-cli-flake";
  };

  outputs = {
    self,
    nixpkgs,
    playwright-cli,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        playwright-cli.packages.${system}.playwright-cli
      ];
    };
  };
}
```

Then run `nix develop` and use `playwright-cli`.

## Supported platforms

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

## Updating

To bump to the latest release, run:

```bash
./update.sh
```

This fetches the latest tag from GitHub, computes the source and npm dependency hashes, and rewrites `versions.nix`.
