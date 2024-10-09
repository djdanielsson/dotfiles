{
  #  darwin-rebuild switch --flake ~/.config/nix#work
  description = "Working Zenful macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.bat
          pkgs.eza
          pkgs.fzf
          pkgs.kubernetes-helm
          pkgs.mkalias
          pkgs.podman
          pkgs.pre-commit
          pkgs.tmux
          pkgs.vim
          pkgs.xstow # c++ version of stow
          pkgs.zoxide
          pkgs.zsh
        ];

      homebrew = {
        enable = true;
        brews = [
          "qemu"
          "python@3.12"
        ];
        casks = [
          "battery"
          "ferdium"
          "gimp"
          "hashicorp-vagrant"
          "hiddenbar"
          "insomnia"
          "logseq"
          "lulu"
          "obs"
          "openshot-video-editor"
          "podman-desktop"
          "utm"
          "vial"
          "visual-studio-code"
          "vlc"
          "warp"
        ];
        masApps = {
          "adbock" = 1402042596;
          "xcode" = 497799835;
          "vmwareRemoteConsole" = 1230249825;
          "bitwarden" = 1352778147;
        };
#        onActivation.cleanup = "zap";
      };

      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';

      system.defaults = {
        dock.persistent-apps = [
          # "/System/Library/CoreServices/Finder.app"
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
          "/Applications/Wave.app"
          "/System/Applications/iPhone Mirroring.app"
          # "${pkgs.alacritty}/Applications/Alacritty.app"
        ];
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."work" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            # Apple Silicon Only
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "ddaniels";
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."work".pkgs;
  };
}
