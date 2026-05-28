{
  module = { config, lib, pkgs, sloth, ... }:
  {
    config = {
      dbus.policies = {
        "${config.flatpak.appId}" = "own";
        "${config.flatpak.appId}.*" = "own";
        "org.freedesktop.DBus" = "talk";
        "org.gtk.vfs.*" = "talk";
        "org.gtk.vfs" = "talk";
        "ca.desrt.dconf" = "talk";
        "org.freedesktop.portal.*" = "talk";
        "org.a11y.Bus" = "talk";
      };
      gpu.enable = lib.mkDefault true;
      gpu.provider = "bundle";
      fonts.enable = true;
      locale.enable = true;
      timeZone.enable = true;
      bubblewrap = {
        network = lib.mkDefault false;
        sockets = {
          wayland = true;
          pulse = true;
        };
        tmpfs = [
          sloth.appsDir
        ];
        bind.rw = [
          sloth.appDir

          (sloth.concat' sloth.runtimeDir "/at-spi/bus")
          (sloth.concat' sloth.runtimeDir "/gvfsd")
          (sloth.concat' sloth.runtimeDir "/dconf")
          (sloth.concat' sloth.runtimeDir "/doc")

          # Per-appId /tmp directory
          # https://github.com/flatpak/flatpak/commit/b65b3f6eadd51bd6600df2c0d07f902a552163d2
          [
            (sloth.mkdir (sloth.concat' sloth.runtimeDir "/.flatpak/${config.flatpak.appId}/tmp"))
            "/tmp"
          ]
        ];
        bind.ro = [
          (sloth.concat' sloth.xdgConfigHome "/gtk-2.0")
          (sloth.concat' sloth.xdgConfigHome "/gtk-3.0")
          (sloth.concat' sloth.xdgConfigHome "/gtk-4.0")
          (sloth.concat' sloth.xdgConfigHome "/fontconfig")
          (sloth.concat' sloth.xdgConfigHome "/dconf")
        ];
        env = {
          FLATPAK_ID = config.flatpak.appId;
          XDG_DATA_DIRS = lib.makeSearchPath "share" [
            pkgs.adwaita-icon-theme
            pkgs.shared-mime-info
          ];
          XCURSOR_PATH = lib.concatStringsSep ":" [
            "${pkgs.adwaita-icon-theme}/share/icons"
            "${pkgs.adwaita-icon-theme}/share/pixmaps"
          ];
          XDG_DATA_HOME = sloth.appDataDir;
          XDG_CONFIG_HOME = sloth.appConfigDir;
          XDG_CACHE_HOME = sloth.appCacheDir;
          XDG_STATE_HOME = sloth.appStateDir;
          HOST_XDG_DATA_HOME = sloth.xdgDataHome;
          HOST_XDG_CONFIG_HOME = sloth.xdgConfigHome;
          HOST_XDG_CACHE_HOME = sloth.xdgCacheHome;
          HOST_XDG_STATE_HOME = sloth.xdgStateHome;
        };
      };
    };
  };
}
