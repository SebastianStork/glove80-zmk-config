{
  description = "Glove80 ZMK firmware (TailorKey layout)";

  inputs.zmk = {
    url = "github:moergo-sc/zmk";
    flake = false;
  };

  outputs =
    { zmk, ... }:
    let
      system = "x86_64-linux";
      # moergo's build pins its own nixpkgs; reuse it so the firmware matches
      # what their CI / cachix produces.
      firmware = import zmk {
        pkgs = import "${zmk}/nix/pinned-nixpkgs.nix" { inherit system; };
      };
      keymap = ./config/glove80.keymap;
      glove80_left = firmware.zmk.override { board = "glove80_lh"; inherit keymap; };
      glove80_right = firmware.zmk.override { board = "glove80_rh"; inherit keymap; };
    in
    {
      packages.${system}.default = firmware.combine_uf2 glove80_left glove80_right;
    };
}
