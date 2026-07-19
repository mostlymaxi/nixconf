{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  # tmux-mcp only understands bash/zsh/fish exit-status markers; anything else
  # (nu, none) gets its bash fallback
  tmuxMcpShell =
    if elem config.shell.default [
      "bash"
      "zsh"
      "fish"
    ] then
      config.shell.default
    else
      "bash";

  # no upstream flake or nixpkgs packaging; built from source so the bin gets
  # a store-path node shebang (npx-fetched bins keep `#!/usr/bin/env node`,
  # which fails since node is not on PATH)
  tmux-mcp = pkgs.buildNpmPackage {
    pname = "tmux-mcp";
    version = "0.2.2";
    src = pkgs.fetchFromGitHub {
      owner = "nickgnd";
      repo = "tmux-mcp";
      rev = "ec68b1061cf3b0d1faa9c5ef5e3f703918e07ba8";
      hash = "sha256-rZhVjuWRlVSjLthgSKbfuPpQQKP9YC2Pjun/6JQYUo0=";
    };
    npmDepsHash = "sha256-N1j8yBC1zQiUTnpfVw2ppY2kh4kJvT88kpTlB1kCBKY=";
    meta.mainProgram = "tmux-mcp";
  };
in
{
  programs.claude-code = mkIf config.programs.core.enable {
    enable = true;

    # tmux mcp: claude can read panes / send keys in the current tmux server
    mcpServers.tmux = {
      type = "stdio";
      command = getExe tmux-mcp;
      args = [ "--shell-type=${tmuxMcpShell}" ];
    };
  };
}
