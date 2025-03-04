_: {
  imports = [
    ./hardware.nix

    ../../modules/common.nix
    ../../modules/nix.nix
    ../../modules/wifi.nix
    ../../modules/firewall.nix
    ../../modules/doas.nix

    ../../modules/packages.nix

    ../../modules/git.nix
    ../../modules/ssh.nix

    ../../modules/vaultix.nix
    ./vaultix.nix

    ../../modules/v2ray.nix

    ../../modules/clickhouse.nix

    ../../modules/rpi.nix

    ../../users/rpi.nix
  ];

  networking.hostName = "rpi";

  # state version, never change this
  system.stateVersion = "25.05";
}
