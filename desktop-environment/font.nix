{
  pkgs,
  style,
  ...
}:

{
  fonts.packages = [
    (style.font.package pkgs)
  ];
}
