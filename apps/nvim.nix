{
  inputs,
  ...
}:

{
  imports = [ inputs.nvf.nixosModules.nvf ];
  programs.nvf = {
    enable = true;
    settings.vim = {
      vimAlias = true;
      syntaxHighlighting = true;
      options = {
        shiftwidth = 2;
      };
      lsp = {
        enable = true;
        formatOnSave = true;
        inlayHints.enable = true;
      };
      languages = {
        nix.enable = true;
        clang = {
          enable = true;
          lsp.enable = true;
        };
      };
      #lazy = {
      #  enable = true;
      #  plugins = {
      #    lualine-nvim = {
      #      enabled = true;
      #    };
      #  };
      #};
    };
  };
}
