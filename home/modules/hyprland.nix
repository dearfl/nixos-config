{ pkgs, osConfig, ... }:
{
  config = {
    wayland = {
      windowManager = {
        hyprland = {
          enable = true;
          systemd.enable = false;
          # systemd.variables = [ "--all" ];
          settings = {
            monitor = ",preferred,auto,auto";

            # maybe we should replace binary paths?
            "$terminal" = "${pkgs.alacritty}/bin/alacritty";
            "$menu" = "${pkgs.wofi}/bin/wofi --show drun";
            "$mod" = "SUPER";

            exec-once = "${pkgs.yambar}/bin/yambar";

            # laptop keyboard, we want norman layout
            device = {
              name = "at-translated-set-2-keyboard";
              kb_layout = "us";
              kb_variant = "norman";
              kb_options = "ctrl:swapcaps";
              resolve_binds_by_sym = "1";
            };

            env = [
              "XCURSOR_SIZE,24"
              "HYPRCURSOR_SIZE,24"
            ];

            general = {
              gaps_in = 5;
              gaps_out = 10;
              border_size = 2;
              layout = "master";
            };

            decoration = {
              rounding = 6;
            };

            animations = {
              enabled = false;
            };

            bind =
              [
                "$mod, Return, exec, $terminal"
                "$mod, Q, killactive"
                "$mod, P, exec, $menu"
                "$mod SHIFT, Q, exit"
                "$mod, M, togglespecialworkspace, magic"
                "$mod SHIFT, M, movetoworkspace, special:magic"
              ]
              ++ (
                # workspaces
                # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
                let
                  mkWorkspaceRule =
                    idx:
                    let
                      ws = toString (idx + 1);
                    in
                    [
                      "$mod, ${ws}, workspace, ${ws}"
                      "$mod SHIFT, ${ws}, movetoworkspace, ${ws}"
                    ];
                in
                builtins.concatLists (builtins.genList mkWorkspaceRule 9)
              );
          };
        };
      };
    };

    # we want some app launcher, default wofi is good enough
    programs.wofi.enable = true;

    # we want some bar
    programs.yambar =
      let
        mkDeco = color: {
          stack = [
            {
              underline = {
                inherit color;
                size = 2;
              };
            }
          ];
        };
      in
      {
        enable = true;
        settings = {
          bar = {
            location = "bottom";
            height = 32;
            background = "222222ff";
            foreground = "dfdfdfff";
            font = "Noto Sans Mono:size=14";
            spacing = 8;
            margin = 16;

            left = [
              {
                clock = {
                  date-format = "%a %d";
                  time-format = "%H:%M";
                  content = [
                    {
                      string = {
                        text = "{date} {time}";
                        deco = mkDeco "0a6cf5ff";
                      };
                    }
                  ];
                };
              }

              # TODO: workspaces
              # this is not working right now, pinging might be able to help
              # {
              #   script = {
              #     path = "${pkgs.yambar-hyprland-wses}/bin/yambar-hyprland-wses";
              #     content.list = {
              #       spacing = 6;
              #       items =
              #         let
              #           mkWorkspaceRule = i: {
              #             map =
              #             let
              #               ws = builtins.toString (i + 1);
              #               count = i + 2;
              #             in
              #             {
              #               default = { string = { text = ws; foreground = "bbbbbbff"; }; };
              #               conditions = {
              #                 "workspace_count < ${builtins.toString count}" = { empty = {}; };
              #                 "workspace_${ws}_focused" = { string = { text = ws; foreground = "fba922ff"; }; };
              #                 "workspace_${ws}_active" = { string = { text = ws; foreground = "ffaa00ff"; }; };
              #                 "workspace_${ws}_windows == 0" = { string = { text = ws; foreground = "555555ff"; }; };
              #               };
              #             };
              #           };
              #         in
              #         builtins.genList mkWorkspaceRule 9;
              #     };
              #   };
              # }

              # app title
              {
                foreign-toplevel.content.map.conditions = {
                  "~activated" = {
                    empty = { };
                  };
                  activated = [
                    {
                      string = {
                        text = "{app-id}";
                        foreground = "fba922ff";
                      };
                    }
                    {
                      string = {
                        text = ": {title}";
                      };
                    }
                  ];
                };
              }
            ];

            right =
              let
                mkNetworkBar = name: {
                  network = {
                    poll-interval = 5000;
                    content.map = {
                      default = {
                        empty = { };
                      };
                      conditions."name == ${name}".map = {
                        default = {
                          string = {
                            text = "<${name}>";
                            foreground = "ffffff66";
                          };
                        };
                        conditions = {
                          "state == down" = {
                            string = {
                              text = "";
                              foreground = "ff0000ff";
                            };
                          };
                          "state == up".map = {
                            deco = mkDeco "9f78e1ff";
                            conditions =
                              let
                                mkSignalRule =
                                  { strength, symbol }:
                                  {
                                    name = "signal >= -${builtins.toString strength}";
                                    value = [
                                      {
                                        string = {
                                          text = "${symbol} {ssid}";
                                        };
                                      }
                                    ];
                                  };
                              in
                              builtins.listToAttrs (
                                map mkSignalRule [
                                  {
                                    strength = 50;
                                    symbol = "🌣";
                                  }
                                  {
                                    strength = 55;
                                    symbol = "🌤";
                                  }
                                  {
                                    strength = 67;
                                    symbol = "🌥";
                                  }
                                  {
                                    strength = 70;
                                    symbol = "🌦";
                                  }
                                  {
                                    strength = 80;
                                    symbol = "🌧";
                                  }
                                ]
                              );
                          };
                        };
                      };
                    };
                  };
                };
              in
              builtins.map mkNetworkBar (
                builtins.filter (name: name != "lo") (builtins.attrNames osConfig.networking.interfaces)
              )
              ++ [
                # cpu usage
                {
                  cpu = {
                    poll-interval = 2000;
                    content.map.conditions."id < 0" = [
                      {
                        string = {
                          text = "💻 {cpu}%";
                          deco = mkDeco "f90000ff";
                        };
                      }
                    ];
                  };
                }
              ];
          };
        };
      };
  };
}
