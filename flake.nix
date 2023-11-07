{
  description = "Wirdnix minimal tools for setup";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; };

  outputs = { self, nixpkgs }: let
    inherit (nixpkgs.lib) genAttrs;
    supportedSystems = [
      "x86_64-linux"
    ];
    forAllSystems = f: genAttrs supportedSystems (system: f system);
  in {
    devShells = forAllSystems (system: let 
      pkgs = import nixpkgs { inherit system; };
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git
        ];
      };
    });
  };
}
