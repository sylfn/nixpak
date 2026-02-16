{
  module = { config, lib, pkgs, sloth, ... }:
  {
    config = {
      bubblewrap = {
        env.DISPLAY = sloth.concat' ":" sloth.pid;
      };
      waylandProxy = {
        enable = true;
        args = [(sloth.concat' "--x-display=" sloth.pid)];
        package = pkgs.symlinkJoin {
          name = "wayland-proxy-virtwl-with-xwayland";
          paths = [pkgs.wayland-proxy-virtwl];
          nativeBuildInputs = [pkgs.makeBinaryWrapper];
          postBuild = ''
            rm $out/bin/wayland-proxy-virtwl
            makeWrapper \
              "${pkgs.wayland-proxy-virtwl}/bin/wayland-proxy-virtwl" \
              $out/bin/wayland-proxy-virtwl \
              --prefix PATH : ${lib.makeBinPath [pkgs.xwayland]}
          '';
          meta.mainProgram = pkgs.wayland-proxy-virtwl.meta.mainProgram;
        };
      };
    };
  };
}
