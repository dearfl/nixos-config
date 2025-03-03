{ inputs, ... }:
{
  imports = [ inputs.vaultix.nixosModules.default ];
  config = {
    # valutix need one of these
    services.userborn.enable = true;
    # systemd.sysuser.enable = true;

    vaultix = {
      settings = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHIZCYb9mgVho/12X1GGlpU884ddWiysq3l3wl5qstCJ";
      };
      secrets = { };
    };
  };
}
