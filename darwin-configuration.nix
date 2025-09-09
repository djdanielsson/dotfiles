# ~/.config/nix/darwin-configuration.nix
{ config, pkgs, self, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ pkgs.mkalias ];

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  system.activationScripts.applications = {
    text =
      let
        # Combine system and user packages that might have GUI apps
        allPackages = config.environment.systemPackages ++ config.home-manager.users.ddaniels.home.packages;

        # Create a derivation that holds all the apps
        guiAppsEnv = pkgs.buildEnv {
          name = "gui-applications";
          paths = allPackages;
          pathsToLink = "/Applications";
        };

        # Use a helper to write a clean, standalone shell script
        linkScript = pkgs.writeShellScriptBin "link-apps" ''
          set -e
          echo "Linking GUI applications into /Applications..." >&2

          # Ensure the target directory exists and is clean
          rm -rf "/Applications/Nix Apps"
          mkdir -p "/Applications/Nix Apps"

          # The path to the app environment is passed as the first argument
          GUI_APPS_DIR="$1"

          # Find all .app bundles and create aliases
          find "$GUI_APPS_DIR/Applications" -maxdepth 1 -type l -exec readlink '{}' + | while read -r src; do
            app_name=$(basename "$src")
            echo "Creating alias for $app_name" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';
      in
      # The final activation script is now a simple, clean call to our generated script
      pkgs.lib.mkForce ''
        ${linkScript}/bin/link-apps ${guiAppsEnv}
      '';
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  system.primaryUser = "ddaniels";

  system.defaults = {
    dock.persistent-apps = [
      "/System/Applications/Launchpad.app"
      "/Applications/Safari.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Calendar.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/Slack.app"
      "/Applications/Logseq.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Photos.app"
      "/System/Applications/Reminders.app"
      "/System/Applications/Notes.app"
      "/System/Applications/Music.app"
      "/System/Applications/App Store.app"
      "/Applications/Managed Software Center.app"
      "/System/Applications/System Settings.app"
      "/Applications/Bitwarden.app"
    ];
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.ddaniels = {
    name = "ddaniels";
    home = "/Users/ddaniels";
  };

  home-manager.backupFileExtension = "backup";

  home-manager.users.ddaniels = import ./home.nix;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
      cleanup = "zap";
    };
<<<<<<< HEAD
    brews = [
      "qemu"
    ];
=======
    brews = [ "qemu" ];
>>>>>>> d8b05bec6c829700426aaf7df67afc5dd7bcf7ee
    casks = [
      "battery"
      "ferdium"
      "gimp"
      "hiddenbar"
      "hoppscotch"
      "libreoffice"
      "logseq"
      "lulu"
      "obs"
      "openshot-video-editor"
      "podman-desktop"
      "utm"
      "vial"
      "visual-studio-code"
      "vlc"
      "vscodium"
      "warp"
    ];
    masApps = {
      "AdBlock" = 1402042596;
      "Bitwarden" = 1352778147;
      "Slack" = 803453959;
      "VMware Remote Console" = 1230249825;
      "Windows App" = 1295203466;
      "Xcode" = 497799835;
    };
  };

  nix-homebrew = {
    enable = true;
    user = "ddaniels";
    enableRosetta = true;
  };
}
