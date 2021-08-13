{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage ./amd_gpu.nix {}
