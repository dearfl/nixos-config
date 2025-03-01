_: {
  imports = [
    ../modules/git.nix
    ../modules/alacritty.nix
    ../modules/hyprland.nix
    ../modules/helix.nix
  ];

  config = {
    home = {
      username = "flr";
      homeDirectory = "/home/flr";
      stateVersion = "24.11";
      sessionVariables.NIXOS_OZONE_WL = "1";
    };

    # let home manager manage itself
    programs.home-manager.enable = true;
  };
}
