{
  description = "my zig project";

  inputs = {
    nixpkgs.url = "github:tacogips/nixpkgs-security/d2a93d2fe7820d90eaa10af53891412ec3614f56";
    flake-utils.url = "github:numtide/flake-utils";
    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls/master";
  };

  # Share the patched Node.js and CA bundle across transitive development inputs.
  inputs.zig.inputs.nixpkgs.follows = "nixpkgs";
  inputs.zls.inputs.nixpkgs.follows = "nixpkgs";

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
