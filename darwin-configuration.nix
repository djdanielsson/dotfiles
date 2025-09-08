{ config, pkgs, self, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.mkalias
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  system.activationScripts.applications.text =
    let
      userPackages = config.home-manager.users.ddaniels.home.packages;
      allPackages = config.environment.systemPackages ++ userPackages;
      guiApps = pkgs.buildEnv {
        name = "gui-applications";
        paths = allPackages;
        pathsToLink = "/Applications";
      };
    in
    pkgs.lib.mkForce ''
      echo "Linking GUI applications into /Applications..." >&2
      rm -rf "/Applications/Nix Apps"
      mkdir -p "/Applications/Nix Apps"
      find "${guiApps}/Applications" -maxdepth 1 -type l -exec readlink '{}' + | while read -r src; do
        app_name=$(basename "$src")
        echo "Creating alias for $app_name" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  # Enable Touch ID for sudo
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

 # Add this line to automatically back up conflicting files 
  home-manager.backupFileExtension = "backup";

  home-manager.users.ddaniels = import ./home.nix;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = zap;
      upgrade = true;
    };
    brews = [ "qemu" ];
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
