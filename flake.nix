{
  description = "magic-cap is a command line utility for an always encrypted archive file type.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = { url = "github:oxalica/rust-overlay"; };
  };
  outputs = { nixpkgs, nixpkgs-unstable, rust-overlay, ... }:
    let
      system = "x86_64-linux";
    in {
      packages.${system}.default =
        let
          pkgs = import nixpkgs { inherit system; };
            in pkgs.rustPlatform.buildRustPackage {
              pname = "iroh_lan";
              buildInputs = [ ];
              version = "0.1.0";
              cargoLock.lockFile = ./Cargo.lock;
              src = pkgs.lib.cleanSource ./.;
            };
            devShells.${system}.default =
              let pkgs = import nixpkgs {
                    inherit system;
                    overlays = [ (import rust-overlay) ];
                    config.allowUnfree = true;
                  };
                  upkgs = import nixpkgs-unstable { inherit system; };
              in
                pkgs.mkShell rec {
                  packages = with pkgs; [
                    # atkmm
                    # cairo
                    # cargo
                    # clippy
                    # ffmpeg-full
                    # freeglut
                    # freeglut.dev
                    # gdk-pixbuf
                    # gdk-pixbuf-xlib
                    # gnome2.gtkglext
                    # gnumake
                    # libgbm
                    # libsoup_3
                    # lld
                    # llvmPackages.clangUseLLVM
                    # nodejs
                    # pango
                    # pipewire
                    # pnpm
                    # vala
                    # wayland-protocols
                    # wayland-scanner
                    # webkitgtk_4_1
                    # webp-pixbuf-loader
                    # xorg.libxcb
                    alsa-lib
                    autoconf
                    automake
                    dbus
                    egl-wayland
                    libGL
                    libtool
                    libxkbcommon
                    pkg-config
                    pkgs.rustPlatform.bindgenHook
                    rust-bin.nightly.latest.default
                    upkgs.rust-analyzer
                    wayland
                    wayland.dev
                  ];
                  shellHook = ''
                  export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath packages}
                  '';
                  # LD_LIBRARY_PATH= "${pkgs.lib.makeLibraryPath buildInputs}";
                };
    };
}
