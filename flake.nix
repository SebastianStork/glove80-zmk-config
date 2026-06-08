{
  description = "Glove80 ZMK firmware (TailorKey layout)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zmk = {
      url = "github:moergo-sc/zmk";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, zmk, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      # moergo's build pins its own nixpkgs; reuse it so the firmware matches
      # what their CI / cachix produces.
      firmware = import zmk {
        pkgs = import "${zmk}/nix/pinned-nixpkgs.nix" { inherit system; };
      };
    in
    {
      packages.${system}.default = import ./config {
        inherit pkgs firmware;
      };
    };
}
