{
  description = "my zig project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls/master";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , zig
    , zls
    ,
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      zig-version = "master";
      pkgs = import nixpkgs {
        inherit system;
      };
      zls-pkg = zls.packages.${system}.default;
      zig-pkg = zig.packages.${system}.${zig-version};
    in

    {
      devShells.default = pkgs.mkShell {

        buildInputs = [ zig-pkg zls-pkg ] ++
          (with pkgs;
          [
            just
          ]);

        shellHook = ''
          [[ -f build.zig ]] || zig init
        '';
      };
    });
}
