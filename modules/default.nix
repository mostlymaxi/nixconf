{ mylib, lib, ... }:
{
  imports = lib.filter (p: baseNameOf p != "system") (mylib.listFiles ./.);
}
