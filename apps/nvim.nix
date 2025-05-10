{ inputs, lib, pkgs, systemSettings, userSettings, ... }:

{
  imports = [ inputs.nixvim.nixosModules.nixvim ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.catppuccin.enable = true;
    lsp = {
      inlayHints.enable = true;
      servers = {
        "*" = {
          settings = {
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
        clangd = {
          enable = true;
          settings = {
            cmd = [
              "clangd"
              "--background-index"
            ];
            filetypes = [
              "c"
              "cpp"
            ];
            root_markers = [
              "compile_commands.json"
              "compile_flags.txt"
            ];
          };
        };
        lua_ls = {
          enable = true;
        };
	nixd = {
	  enable = true;
	  settings = {
	    formatting.cmd = [
	      "${lib.getExe pkgs.nixfmt-rfc-style}"
	    ];
	  };
	};
      };
    };
    plugins.lualine.enable = true;
  };
}

