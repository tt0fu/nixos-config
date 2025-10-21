{
  inputs,
  ...
}:

{
  imports = [ inputs.nixvim.nixosModules.nixvim ];
  programs.nixvim = {
    enable = true;
    lsp = {
      inlayHints.enable = true;

      servers = {
        "*" = {
          config = {
            capabilities = {
              textDocument = {
                semanticTokens = {
                  multilineTokenSupport = true;
                };
              };
            };
            root_markers = [
              ".git"
            ];
          };
        };
        clangd.enable = true;
      };
    };
    colorschemes.catppuccin = {
      enable = true;
      settings.transparent_background = true;
    };
    plugins = {
      lualine.enable = true;
      lsp.enable = true;
      lsp-format.enable = true;
      lsp-signature.enable = true;
      lsp-status.enable = true;
      undotree.enable = true;
    };
  };
}
