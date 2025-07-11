{
  mylib,
  lib,
  config,
  ...
}:
with lib;
{
  imports = mylib.listFiles ./.;
}
