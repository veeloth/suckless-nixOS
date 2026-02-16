{ config, lib, pkgs, nvf, vebar, nhkd, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./system.nix
      ./services.nix
      ./shell.nix
      ./users.nix
      ../pkgs/vlth.nix
      nvf.nixosModules.nvf
    ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfree = true;
  documentation.dev.enable = true;
  documentation.man.man-db.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  fonts.packages = with pkgs;
    [
    scientifica
    ];

  programs.nvf =
    {
    enable = true;
    settings.vim.lsp.enable = true;
    settings.vim =
      {
      lineNumberMode = "relNumber";
      options.shiftwidth = 2;
      options.autoindent = false;
      spellcheck.enable = true;

      autocomplete =    
        {
        nvim-cmp.enable = true;
        };

      languages =
        {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        #nix.enable = true;
        markdown.enable = true;
        clang.enable = true;

        css.enable = true;
        html.enable = true;
        ts.enable = true;

        go.enable = true;
        lua.enable = true;
        python.enable = true;

        clang.treesitter.enable = true;
        };

      filetree.nvimTree.setupOpts.view =
        {
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        };

      visuals.indent-blankline.setupOpts.indent.repeat_linebreak = true;
      
      statusline.lualine =
          {
          enable = true;
          theme = "gruvbox";
          };

      theme =
        {
        enable = true;
        name = "gruvbox";
        style = "dark";
        transparent = true;
        };
      };
    };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

