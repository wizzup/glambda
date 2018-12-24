# shell.nix for nix-shell
# Overrideable ghc version by passing compiler env variable
# Example: 
# $ nix-shell shell.nix --argstr compiler ghc7103
#
# To list avaliable ghc version: 
# $ nix-env -qaPA nixos.haskell.compiler

{ pkgs ? import <nixpkgs> {}, compiler ? "ghc863" }:

with pkgs;
with pkgs.haskell.packages.${compiler};

let
  ghc = ghcWithPackages (ps: with ps; [
          split
          # hspec
          # fgl
        ]);
in
  mkShell {
    name = "${compiler}-sh";
    buildInputs = [ ghc cabal-install ];
    shellHook = ''
      eval "$(egrep ^export "$(type -p ghc)")"
      export PS1="\[\033[1;32m\][$name:\W]\n$ \[\033[0m\]"
    '';
}
