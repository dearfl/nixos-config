_: {
  imports = [
    ./hardware.nix

    ../../modules/common.nix
    ../../modules/nix.nix
    ../../modules/systemd-boot.nix
    ../../modules/wifi.nix
    ../../modules/firewall.nix
    ../../modules/fonts.nix
    ../../modules/doas.nix
    ../../modules/sound.nix
    ../../modules/touchpad.nix

    ../../modules/packages.nix

    ../../modules/git.nix
    ../../modules/ssh.nix
    ../../modules/hyprland.nix

    ../../modules/vaultix.nix
    ./vaultix.nix

    ../../users/flr.nix
  ];

  networking.hostName = "x1c";

  # state version, never change this
  system.stateVersion = "25.05";
}
