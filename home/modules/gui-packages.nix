{ pkgs, ... }:
{
  config = {
    home.packages = [
      pkgs.blender
      # pkgs.kicad
      pkgs.mupdf
      pkgs.sxiv
      pkgs.scrot
      pkgs.telegram-desktop
      pkgs.vial
    ];

    programs = {
      mpv.enable = true;
      obs-studio.enable = true;
    };
  };
}
