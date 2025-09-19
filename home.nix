# ~/.config/nix/home.nix
{ pkgs, ... }:

{
  home.stateVersion = "25.05";

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
    pkgs.kubevirt
    pkgs.kustomize
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
    pkgs.vim
    pkgs.watch
    pkgs.xstow
    pkgs.yamllint
    pkgs.yq-go
    pkgs.z3
    pkgs.zoxide
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" ];
    };
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      lt = "eza -a --tree --level=1";
      vim = "hx";
      gitcm = "git add . ;git gen-commit";
      gitca = "__gitca";
    };
    initContent = ''
      export EDITOR=hx
      export GPG_TTY=$(tty)
      __gitca() {
        git add .
        git commit -am "$(git status | grep -e 'modified:\|deleted:\|added:\|renamed:\|new file:')"
        git push origin $(git status | grep -i "on branch" | awk '{ print $3}')
      }
    '';
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  home.activation.setWallpaper = ''
    wallpaper_path="${./assets/background-dark.png}"

    # Use the full path to the osascript command
    /usr/bin/osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$wallpaper_path\""
  '';

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.home-manager.enable = true;
}
