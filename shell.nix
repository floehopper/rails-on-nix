with (import <nixpkgs> {});
let
  env = bundlerEnv {
    name = "vagrant-bundler-env";
    inherit ruby_2_6;
    gemfile  = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset   = ./gemset.nix;
  };
in stdenv.mkDerivation {
  name = "vagrant";
  buildInputs = [ env nodejs yarn ];
}
