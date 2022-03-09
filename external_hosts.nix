{ config, lib, pkgs, ... }:
{
  networking.extraHosts = let
    additional_blocks = ''
    0.0.0.0 youtube.com
    0.0.0.0 www.youtube.com
    0.0.0.0 bbc.com
    0.0.0.0 www.bbc.com
    0.0.0.0 tagesschau.de
    0.0.0.0 www.tagesschau.de
    0.0.0.0 golem.de
    0.0.0.0 www.golem.de
    0.0.0.0 heise.de
    0.0.0.0 www.heise.de
    '';
  in additional_blocks;


}
