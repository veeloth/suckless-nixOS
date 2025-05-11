{ config, lib, pkgs, nixvim, vebar, nhkd, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./system.nix
      ./services.nix
      ./shell.nix
      ./users.nix
      ../pkgs/vlth.nix
      nixvim.nixosModules.nixvim
    ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfree = true;
  documentation.dev.enable = true;
  documentation.man.man-db.enable = true;

  fonts.packages = with pkgs;
    [
    scientifica
    hermit
    ];

  programs.nixvim =
  {
    enable = true;
    opts =
    {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
    plugins.lsp =
      {
      enable = true;
      servers =
	{
	clangd.enable = true;#C / C++
	nil_ls.enable = true;#nix
	marksman.enable = true;#markdown
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

