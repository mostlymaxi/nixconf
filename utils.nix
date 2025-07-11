{ lib, ... }: {
  # utility function from Ryan Yin's nix config
  # to get a list of files from a path
  # https://github.com/ryan4yin/nix-config/blob/90d411b9432dcf3ac30231006b5fb3ed23c0c3ce/lib/default.nix#L13

  listFiles = path:
    builtins.map
      (f: (path + "/${f}"))
      (builtins.attrNames
        (lib.attrsets.filterAttrs
          (
            path: _type:
              (_type == "directory") # include directories
              || (
                (path != "default.nix") # ignore default.nix
                && (lib.strings.hasSuffix ".nix" path) # include .nix files
              )
          )
          (builtins.readDir path)));

}
