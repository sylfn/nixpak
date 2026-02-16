{
  lib.nixpak = import ./modules;

  profiles = {
    gui-base = (import ./contrib/modules/gui-base.nix).module;
    mpris2-player = (import ./contrib/modules/mpris2-player.nix).module;
    network = (import ./contrib/modules/network.nix).module;
    xwayland = (import ./contrib/modules/xwayland.nix).module;
  };
}
