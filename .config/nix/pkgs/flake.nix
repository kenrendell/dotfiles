{
  inputs = {
    flakey-profile.url = "github:lf-/flakey-profile";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, flakey-profile }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        # Any extra arguments to mkProfile are forwarded directly to pkgs.buildEnv.
        #
        # Usage:
        # Switch to this flake:
        #   nix run .#profile.switch
        # Revert a profile change:
        #   nix run .#profile.rollback
        # Build, without switching:
        #   nix build .#profile
        # Update package versions:
        #   nix flake update
        #   nix run .#profile.switch
        # Pin nixpkgs in the flake registry and in NIX_PATH, so that
        # `nix run nixpkgs#hello` and `nix-shell -p hello --run hello` will
        # resolve to the same hello as below [should probably be run as root, see README caveats]:
        #   sudo nix run .#profile.pin
        packages.profile = flakey-profile.lib.mkProfile {
          inherit pkgs;
          # Specifies things to pin in the flake registry and in NIX_PATH.
          pinned = { nixpkgs = toString nixpkgs; };
          paths = with pkgs; [
            # EDA tools
            xschem
            ngspice
            #xyce
            xyce-parallel
            #trilinos
            trilinos-mpi
            ghdl
            iverilog
            gaw
            gtkwave
            gnuplot
            magic-vlsi
            klayout
            #xcircuit
            qucs-s
            kicad
            fritzing
            verible
            nextpnr
            verilator
            yosys

            # For Klayout
            #python313Packages.python
            #python313Packages.pip
            #python313Packages.gdsfactory
            #python313Packages.kfactory
            #python313Packages.klayout
            #python313Packages.toolz
            #python313Packages.aenum
            #python313Packages.gitpython
            #python313Packages.gitdb
            #python313Packages.smmap
            #python313Packages.loguru
            #python313Packages.rich
            #python313Packages.python-dotenv
            #python313Packages.pydantic
            #python313Packages.pydantic-core
            #python313Packages.typing-extensions
            #python313Packages.typing-inspection

            # GPU
            glxinfo

            # Distributed computing
            mpi

            # Drawing tools
            inkscape
            ipe

            # Notes
            emanote

            # Document Viewer
            sioyek

            # Octave
            octave
            octavePackages.symbolic
            octavePackages.control
            octavePackages.signal
            octavePackages.image
            octavePackages.instrument-control

            # Command-line
            yash
            exercism
            cointop

            # IoT
            mqttui
            nodePackages.node-red

            # Desktop Applications
            # NixGL required
            teams-for-linux
            telegram-desktop
            vesktop
            audacity
            shotcut
          ];
        };
      });
}
