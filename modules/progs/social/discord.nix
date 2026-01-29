{
  home =
    { inputs, pkgs, ... }:
    {
      # home.packages = [ pkgs.discord ];
      imports = [
        inputs.nixcord.homeModules.nixcord
      ];
      programs.nixcord = {
        enable = true;
        vesktop = {
          enable = true;
          package = pkgs.vesktop.overrideAttrs (old: {
            preBuild = ''
              cp -r ${pkgs.electron.dist} electron-dist
              chmod -R u+w electron-dist
            '';
            buildPhase = ''
              runHook preBuild

              pnpm build
              pnpm exec electron-builder \
                --dir \
                -c.asarUnpack="**/*.node" \
                -c.electronDist="electron-dist" \
                -c.electronVersion=${pkgs.electron.version}

              runHook postBuild
            '';
          });
        };
        quickCss = ''
          * {
            --border-faint: white !important;
            --border-subtle: white !important;
            --border-normal: white !important;
            --border-strong: white !important;
            --app-border-frame: white !important;
            --input-border: white;
            --button-filled-brand-border: white;
            --button-danger-border: white;
            --user-profile-border: white;

            --action-sheet-gradient-bg: transparent !important;
            --activity-card-background: transparent !important;
            --alert-bg: transparent !important;
            --android-navigation-bar-background: transparent !important;
            --android-navigation-scrim-background: transparent !important;
            --app-background-frame: transparent !important;
            --autocomplete-bg: black !important;
            --background-accent: transparent !important;
            --background-base-low: black !important;
            --background-base-lower: transparent !important;
            --background-base-lowest: transparent !important;
            --background-code-addition: transparent !important;
            --background-code-deletion: transparent !important;
            --background-code: transparent !important;
            --background-feedback-critical: transparent !important;
            --background-feedback-info: transparent !important;
            --background-feedback-positive: transparent !important;
            --background-feedback-warning: transparent !important;
            --background-floating: black !important;
            --background-mentioned-hover: transparent !important;
            --background-mentioned: transparent !important;
            --background-message-automod-hover: transparent !important;
            --background-message-automod: transparent !important;
            --background-message-highlight-hover: transparent !important;
            --background-message-highlight: transparent !important;
            --background-message-hover: transparent !important;
            --background-modifier-accent: transparent !important;
            --background-modifier-active: transparent !important;
            --background-modifier-hover: transparent !important;
            --background-modifier-selected: transparent !important;
            --background-nested-floating: transparent !important;
            --background-primary: transparent !important;
            --background-secondary-alt: transparent !important;
            --background-secondary: transparent !important;
            --background-surface-high: black !important;
            --background-surface-higher: black !important;
            --background-surface-highest: black !important;
            --background-tertiary: transparent !important;
            --background-tile-gradient-pink-end: transparent !important;
            --background-tile-gradient-pink-start: transparent !important;
            --badge-brand-bg: transparent !important;
            --bg-backdrop-immersive: transparent !important;
            --bg-backdrop-no-opacity: transparent !important;
            --bg-backdrop: transparent !important;
            --bg-base-primary: transparent !important;
            --bg-base-secondary: transparent !important;
            --bg-base-tertiary: transparent !important;
            /* --bg-brand: white !important; */
            --bg-mod-faint: transparent !important;
            --bg-mod-strong: transparent !important;
            --bg-mod-subtle: transparent !important;
            --bg-overlay-1: transparent !important;
            --bg-overlay-2: transparent !important;
            --bg-overlay-3: transparent !important;
            --bg-overlay-4: transparent !important;
            --bg-overlay-app-frame: transparent !important;
            --bg-overlay-chat: transparent !important;
            --bg-overlay-floating: black !important;
            --bg-overlay-home-card: transparent !important;
            --bg-overlay-home: transparent !important;
            --bg-surface-overlay-tmp: transparent !important;
            --bg-surface-overlay: black !important;
            --bg-surface-raised: transparent !important;
            --bug-reporter-modal-submitting-background: transparent !important;
            --button-creator-revenue-background: transparent !important;
            --button-danger-background-active: transparent !important;
            --button-danger-background-disabled: transparent !important;
            --button-danger-background-hover: transparent !important;
            --button-danger-background: transparent !important;
            --button-expressive-background-active: transparent !important;
            --button-expressive-background-hover: transparent !important;
            --button-expressive-background: transparent !important;
            --button-filled-brand-background-active: transparent !important;
            --button-filled-brand-background-hover: transparent !important;
            --button-filled-brand-background: transparent !important;
            --button-filled-brand-inverted-background-active: transparent !important;
            --button-filled-brand-inverted-background-hover: transparent !important;
            --button-filled-brand-inverted-background: transparent !important;
            --button-filled-white-background-active: transparent !important;
            --button-filled-white-background-hover: transparent !important;
            --button-filled-white-background: transparent !important;
            --button-outline-brand-background-active: transparent !important;
            --button-outline-brand-background-hover: transparent !important;
            --button-outline-brand-background: transparent !important;
            --button-outline-danger-background-active: transparent !important;
            --button-outline-danger-background-hover: transparent !important;
            --button-outline-danger-background: transparent !important;
            --button-outline-positive-background-active: transparent !important;
            --button-outline-positive-background-hover: transparent !important;
            --button-outline-positive-background: transparent !important;
            --button-outline-primary-background-active: transparent !important;
            --button-outline-primary-background-hover: transparent !important;
            --button-outline-primary-background: transparent !important;
            --button-positive-background-active: transparent !important;
            --button-positive-background-disabled: transparent !important;
            --button-positive-background-hover: transparent !important;
            --button-positive-background: transparent !important;
            --button-secondary-background-active: transparent !important;
            --button-secondary-background-disabled: transparent !important;
            --button-secondary-background-hover: transparent !important;
            --button-secondary-background: transparent !important;
            --button-transparent-background-active: transparent !important;
            --button-transparent-background-hover: transparent !important;
            --button-transparent-background: transparent !important;
            --card-gradient-bg: transparent !important;
            --card-primary-bg: transparent !important;
            --card-primary-pressed-bg: transparent !important;
            --card-secondary-bg: transparent !important;
            --card-secondary-pressed-bg: transparent !important;
            --channeltextarea-background: transparent !important;
            --chat-background-default: transparent !important;
            --chat-background: transparent !important;
            --chat-banner-bg: transparent !important;
            --chat-input-container-background: transparent !important;
            --chat-swipe-to-reply-background: transparent !important;
            --chat-swipe-to-reply-gradient-background: transparent !important;
            --checkbox-background-checked: transparent !important;
            --checkbox-background-default: transparent !important;
            --coachmark-bg: transparent !important;
            --content-inventory-overlay-ui-mod-bg: transparent !important;
            --context-menu-backdrop-background: transparent !important;
            --creator-revenue-info-box-background: transparent !important;
            --custom-status-bubble-bg: transparent !important;
            --deprecated-card-bg: transparent !important;
            --deprecated-card-editable-bg: transparent !important;
            --deprecated-text-input-bg: transparent !important;
            --display-banner-overflow-background: transparent !important;
            --embed-background-alternate: transparent !important;
            --embed-background: transparent !important;
            --expression-picker-bg: transparent !important;
            --forum-post-extra-media-count-container-background: transparent !important;
            --forum-post-tag-background: transparent !important;
            --guild-notifications-bottom-sheet-pill-background: transparent !important;
            --home-background: transparent !important;
            --info-box-background: transparent !important;
            --info-danger-background: transparent !important;
            --info-help-background: transparent !important;
            --info-positive-background: transparent !important;
            --info-warning-background: transparent !important;
            --input-background: transparent !important;
            --input-error-background: transparent !important;
            --mention-background: transparent !important;
            --menu-item-danger-active-bg: transparent !important;
            --menu-item-danger-hover-bg: transparent !important;
            --menu-item-default-active-bg: transparent !important;
            --menu-item-default-hover-bg: transparent !important;
            --message-reacted-background: transparent !important;
            --modal-background: black !important;
            --modal-footer-background: transparent !important;
            --notice-background-critical: transparent !important;
            --notice-background-info: transparent !important;
            --notice-background-positive: transparent !important;
            --notice-background-warning: transparent !important;
            --panel-bg: transparent !important;
            --polls-normal-image-background: transparent !important;
            --profile-gradient-note-background: transparent !important;
            --profile-gradient-role-pill-background: transparent !important;
            --spoiler-hidden-background-hover: transparent !important;
            --spoiler-hidden-background: transparent !important;
            --spoiler-revealed-background: transparent !important;
            --stage-card-pill-bg: transparent !important;
            --status-danger-background: transparent !important;
            --status-positive-background: transparent !important;
            --status-warning-background: transparent !important;
            --toast-bg: transparent !important;
            --transparentesign-button-active-background: transparent !important;
            --transparentesign-button-active-pressed-background: transparent !important;
            --transparentesign-button-danger-background: transparent !important;
            --transparentesign-button-danger-pressed-background: transparent !important;
            --transparentesign-button-danger-text: transparent !important;
            --transparentesign-button-destructive-background: transparent !important;
            --transparentesign-button-destructive-pressed-background: transparent !important;
            --transparentesign-button-overlay-alpha-background: transparent !important;
            --transparentesign-button-overlay-alpha-pressed-background: transparent !important;
            --transparentesign-button-overlay-background: transparent !important;
            --transparentesign-button-positive-background: transparent !important;
            --transparentesign-button-positive-pressed-background: transparent !important;
            --transparentesign-button-premium-primary-pressed-background: transparent !important;
            --transparentesign-button-primary-alt-background: transparent !important;
            --transparentesign-button-primary-alt-on-blurple-background: transparent !important;
            --transparentesign-button-primary-alt-on-blurple-pressed-background: transparent !important;
            --transparentesign-button-primary-alt-pressed-background: transparent !important;
            --transparentesign-button-primary-background: transparent !important;
            --transparentesign-button-primary-overlay-background: transparent !important;
            --transparentesign-button-primary-overlay-pressed-background: transparent !important;
            --transparentesign-button-primary-pressed-background: transparent !important;
            --transparentesign-button-secondary-background: transparent !important;
            --transparentesign-button-secondary-overlay-background: transparent !important;
            --transparentesign-button-secondary-overlay-pressed-background: transparent !important;
            --transparentesign-button-secondary-pressed-background: transparent !important;
            --transparentesign-button-selected-background: transparent !important;
            --transparentesign-button-selected-pressed-background: transparent !important;
            --transparentesign-button-tertiary-background: transparent !important;
            --transparentesign-button-tertiary-pressed-background: transparent !important;
            --transparentesign-chat-input-background: transparent !important;
            --transparentesign-image-button-pressed-background: transparent !important;
            --transparentesign-input-control-active-bg: transparent !important;
            --typing-indicator-bg: transparent !important;
            --user-profile-background-hover: transparent !important;
            --user-profile-header-overflow-background: transparent !important;
            --user-profile-note-background-focus: transparent !important;
            --user-profile-overlay-background-hover: transparent !important;
            --user-profile-overlay-background: transparent !important;
            --user-profile-toolbar-background: transparent !important;
            --voice-video-video-tile-background: transparent !important;
          }
        '';
        config = {
          frameless = true;
          useQuickCss = true;
          transparent = true;
        };
      };
      wayland.windowManager.hyprland.settings.bind = [
        "SUPER, D, exec, discord"
      ];
      # programs.niri.settings.binds."Mod+D".action.spawn = [ "discord" ];
    };
}
