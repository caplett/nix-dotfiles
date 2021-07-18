#  Copied from: https://cloud.tissot.de/gitea/benneti/nixos/src/commit/413600f8a9a79d3bce8521ac37caa95dd1642286/profiles/hardware/amd_gpu.nix
{ config, lib, pkgs, ... }:
{
  boot.initrd.kernelModules = [
    "amdgpu"
  ];
  hardware = {
    opengl = {
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];
      driSupport = true;
    };
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
}
