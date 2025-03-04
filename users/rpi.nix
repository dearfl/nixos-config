_: {
  config = {
    users.users.flr = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = [ ];
      # raspberry pi sd-image used 1000, so we settle for 1001
      uid = 1001;
    };
  };
}

