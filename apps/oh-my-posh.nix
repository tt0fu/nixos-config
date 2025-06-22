{
  inputs,
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager.users.${userSettings.username} =
    { pkgs, ... }:
    {
      programs = {
        bash.enable = true;
        oh-my-posh = {
          enable = true;
          enableBashIntegration = true;
          settings = {
            "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
            "palette" = {
              "red" = "#FF0000";
              "green" = "#00FF00";
              "blue" = "#0000FF";
              "white" = "#FFFFFF";
              "black" = "#111111";
              "orange" = "#FF7700";
              "0" = "#FFC2DB";
              "1" = "#FFCBA1";
              "2" = "#EAE192";
              "3" = "#A9F2C0";
              "4" = "#87F1FE";
              "5" = "#B4E1FF";
              "6" = "#F1CCFF";
            };
            "blocks" = [
              {
                alignment = "left";
                segments = [
                  {
                    background = "p:0";
                    foreground = "p:black";
                    leading_diamond = "╭─";
                    properties = {
                      linux = "";
                      macos = "";
                      windows = "";
                    };
                    style = "diamond";
                    template = "{{ if .WSL }}WSL at {{ end }}{{.Icon}} ";
                    type = "os";
                  }
                  {
                    background = "p:1";
                    foreground = "p:black";
                    powerline_symbol = "";
                    style = "powerline";
                    template = " {{ .Name }} ";
                    type = "shell";
                  }
                  {
                    background = "p:red";
                    foreground = "p:black";
                    style = "diamond";
                    template = "<parentBackground></>  ";
                    type = "root";
                  }
                  {
                    background = "p:2";
                    foreground = "p:black";
                    powerline_symbol = "";
                    properties = {
                      style = "full";
                    };
                    style = "powerline";
                    template = " {{ .Path }} ";
                    type = "path";
                  }
                  {
                    background = "p:3";
                    foreground = "p:black";
                    powerline_symbol = "";
                    properties = {
                      "branch_icon" = " ";
                      "fetch_status" = true;
                      "fetch_upstream_icon" = true;
                    };
                    style = "powerline";
                    template = " {{ .UpstreamIcon }} {{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}</>{{ end }} ";
                    type = "git";
                  }
                  {
                    background = "p:4";
                    foreground = "p:black";
                    properties = {
                      style = "roundrock";
                      threshold = 0;
                    };
                    style = "diamond";
                    template = " {{ .FormattedMs }}⠀";
                    trailing_diamond = "";
                    type = "executiontime";
                  }
                ];
                type = "prompt";
              }
              {
                alignment = "right";
                segments = [
                  {
                    background = "p:5";
                    foreground = "p:black";
                    invert_powerline = true;
                    powerline_symbol = "";
                    properties = {
                      charged_icon = " ";
                      charging_icon = " ";
                      discharging_icon = " ";
                    };
                    style = "powerline";
                    template = " {{ if not .Error }}{{ .Icon }}{{ .Percentage }}{{ end }}{{ .Error }} ";
                    type = "battery";
                  }
                  {
                    background = "p:6";
                    foreground = "p:black";
                    invert_powerline = true;
                    leading_diamond = "";
                    properties = {
                      time_format = "Jan _2, 15:04";
                    };
                    style = "diamond";
                    template = " {{ .CurrentDate | date .Format }} ";
                    trailing_diamond = "";
                    type = "time";
                  }
                ];
                type = "prompt";
              }
              {
                alignment = "left";
                newline = true;
                segments = [
                  {
                    foreground = "p:0";
                    style = "plain";
                    template = "╰─";
                    type = "text";
                  }
                  {
                    foreground = "p:0";
                    properties = {
                      always_enabled = true;
                    };
                    style = "plain";
                    template = " ";
                    type = "status";
                  }
                ];
                type = "prompt";
              }
            ];
            version = 3;
          };
        };
      };
    };
}
