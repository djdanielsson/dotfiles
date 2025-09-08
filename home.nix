{ pkgs, ... }:

{
  home.stateVersion = "23.11";

  # All your CLI tools, managed by Nix
  home.packages = [
    pkgs.ansible-language-server
    pkgs.ansible-lint
    pkgs.bat
    pkgs.eza
    pkgs.fzf
    pkgs.gnupg
    pkgs.helix
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.mas
    pkgs.neovim
    pkgs.nodejs
    pkgs.podman
    pkgs.pre-commit
    pkgs.python313
    pkgs.rustup
    pkgs.sqlite
    pkgs.sshpass
    pkgs.tmux
    pkgs.tree
    pkgs.tree-sitter
    pkgs.unbound
    pkgs.kubevirt
    pkgs.watch
    pkgs.vim
    pkgs.xstow
    pkgs.yamllint
    pkgs.yq-go
    pkgs.z3
    pkgs.zoxide
  ];

  # Declarative Zsh configuration
  programs.zsh = {
    enable = true;
    # Let Home Manager manage .zshrc
    enableCompletion = true;
    autocd = true;

    # Oh My Zsh settings
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" ]; # Add other plugins here, e.g., "docker"
    };

    # Your custom aliases
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      lt = "eza -a --tree --level=1";
      vim = "hx";
      gitcm = "git add . ;git gen-commit"; # Note: you need to have `git gen-commit` installed
      gitca = "__gitca";
    };

    # Your custom functions and startup commands
    initContent = ''
      # Preferred editor
      export EDITOR=hx

      # For GPG
      export GPG_TTY=$(tty)

      # Git commit and push function
      __gitca() {
        git add .
        git commit -am "$(git status | grep -e 'modified:\|deleted:\|added:\|renamed:\|new file:')"
        git push origin $(git status | grep -i "on branch" | awk '{ print $3}')
      }
    '';

    # Plugins managed by Home Manager
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Activation script to set wallpaper
  home.activation.setWallpaper = ''
    wallpaper_path="''${/Users/ddaniels/Pictures/Wallpapers/background-dark.png}"
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$wallpaper_path\""
  '';

  # Declarative FZF integration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
