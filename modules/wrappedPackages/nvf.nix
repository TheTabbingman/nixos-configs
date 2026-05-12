{
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.nvf =
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          {
            config.vim = {
              keymaps = [
                {
                  key = "<Esc>";
                  mode = "n";
                  action = "<cmd>nohlsearch<CR>";
                  desc = "Clear highlights on search when pressing <Esc> in normal mode";
                }
                {
                  key = "<leader>q";
                  mode = "n";
                  lua = true;
                  action = "vim.diagnostic.setloclist";
                  desc = "Open diagnostic [Q]uickfix list";
                }
                {
                  key = "<Esc><Esc>";
                  mode = "t";
                  action = "<C-\\><C-n>"; # NOTE: Don't know if this should be \\ or \
                  desc = "Exit terminal mode";
                }
                {
                  key = "<C-h>";
                  mode = "n";
                  action = "<C-w><C-h>";
                  desc = "Move focus to the left window";
                }
                {
                  key = "<C-l>";
                  mode = "n";
                  action = "<C-w><C-l>";
                  desc = "Move focus to the right window";
                }
                {
                  key = "<C-j>";
                  mode = "n";
                  action = "<C-w><C-j>";
                  desc = "Move focus to the lower window";
                }
                {
                  key = "<C-k>";
                  mode = "n";
                  action = "<C-w><C-k>";
                  desc = "Move focus to the upper window";
                }
                {
                  key = "<leader>/";
                  mode = "n";
                  desc = "[/] Fuzzily search in current buffer";
                  lua = true;
                  action = "require('telescope.builtin').current_buffer_fuzzy_find";
                }
                {
                  key = "<leader>s/";
                  mode = "n";
                  desc = "[S]earch [/] in Open Files";
                  lua = true;
                  action = ''
                    function()
                      require('telescope.builtin').live_grep {
                        grep_open_files = true,
                        prompt_title = 'Live Grep in Open Files',
                      }
                    end
                  '';
                }
                {
                  key = "<leader><leader>";
                  mode = "n";
                  desc = "Open Diagnostic Window";
                  lua = true;
                  action = "vim.diagnostic.open_float"; # NOTE:Should maybe be vim.lsp.buf.hover instead?
                }
                {
                  key = "<leader>y";
                  mode = ["n" "v"];
                  desc = "Copy to system clipboard";
                  action = ''"+y'';
                }
                {
                  key = "<leader>Y";
                  mode = ["n" "v"];
                  desc = "Copy line to system clipboard";
                  action = ''"+Y'';
                }
                {
                  key = "<leader>p";
                  mode = ["n" "v"];
                  desc = "Paste from system clipboard";
                  action = ''"+p'';
                }
              ];
              theme = {
                enable = true;
                name = "onedark";
                style = "dark";
              };
              treesitter.enable = true;
              lineNumberMode = "relNumber";
              undoFile.enable = true;
              searchCase = "smart";
              options = {
                cursorline = true;
                cursorlineopt = "both";
                inccommand = "split";
                scrolloff = 10;
                list = true;
                listchars = "tab:» ,trail:·,nbsp:␣";
                breakindent = true;
                showmode = false;
                confirm = true;
              };
              binds.whichKey = {
                enable = true;
                setupOpts = {
                  delay = 0;
                  icons.mappings = true;
                };
              };
              telescope = {
                enable = true;
                extensions = [
                  {
                    name = "fzf";
                    packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
                    # setup = {fzf = {fuzzy = true;};}; # This isn't in the kickstart config but is on the example on nvf
                  }
                  {
                    name = "ui-select";
                    packages = [pkgs.vimPlugins.telescope-ui-select-nvim];
                  }
                ];
                mappings = {
                  # NOTE: Maybe I could just put the 'search' things in s and leave the rest default?
                  buffers = "<leader>sb";
                  diagnostics = "<leader>sld";
                  findFiles = "<leader>sf";
                  findProjects = "<leader>fp";
                  gitBranches = "<leader>svb";
                  gitBufferCommits = "<leader>svcb";
                  gitCommits = "<leader>svcw";
                  gitFiles = "<leader>svf";
                  gitStash = "<leader>svx";
                  gitStatus = "<leader>svs";
                  helpTags = "<leader>sh";
                  liveGrep = "<leader>sg";
                  lspDefinitions = "<leader>slD";
                  lspDocumentSymbols = "<leader>slsb";
                  lspImplementations = "<leader>sli";
                  lspReferences = "<leader>slr";
                  lspTypeDefinitions = "<leader>slt";
                  lspWorkspaceSymbols = "<leader>slsw";
                  open = "<leader>ss";
                  resume = "<leader>sr";
                  treesitter = "<leader>st";
                };
                setupOpts.defaults = {
                  color_devicons = true;
                  layout_config = {
                    height = 0.9;
                    horizontal = {
                      preview_width = 0.4;
                      prompt_position = "bottom";
                    };
                  };
                  selection_caret = ">";
                };
              };
              visuals.nvim-web-devicons.enable = true;
              lsp = {
                enable = true;
                inlayHints.enable = true;
                formatOnSave = true;
              };
              formatter.conform-nvim.enable = true;
              visuals.fidget-nvim.enable = true;
              autocomplete.blink-cmp.enable = true;
              languages = {
                enableFormat = true;
                enableTreesitter = true;
                enableDAP = true;
                lua.enable = true;
                clang.enable = true;
                typescript.enable = true;
                python.enable = true;
                nix = {
                  # TODO: Setup the rest of the way
                  enable = true;
                  lsp.servers = ["nixd"];
                };
              };
              debugger = {
                nvim-dap = {
                  enable = true;
                  ui.enable = true;
                };
              };
              autopairs.nvim-autopairs.enable = true;
              notes.todo-comments.enable = true;
              visuals.indent-blankline.enable = true;
              diagnostics.nvim-lint.enable = true;
              git = {
                enable = true;
                gitsigns = {
                  enable = true;
                  setupOpts = {
                    signs = {
                      add = "text:+";
                      change = "text:~";
                      delete = "text:_";
                      topdelete = "text:‾";
                      changedelete = "text:~";
                    };
                  };
                };
              };
              tabline.nvimBufferline = {
                enable = true;
                mappings = {
                  closeCurrent = "<A-c>";
                  cycleNext = "<A-.>";
                  cyclePrevious = "<A-,>";
                  moveNext = "<A-S-.>";
                  movePrevious = "<A-S-,>";
                };
                setupOpts.options.numbers = "none";
              };
              utility.yazi-nvim = {
                enable = true;
                mappings.openYazi = ''\'';
              };
              terminal.toggleterm = {
                enable = true;
                lazygit.enable = true;
              };
              augroups = [
                {
                  name = "kickstart-highlight-yank";
                  clear = true;
                }
              ];
              autocmds = [
                {
                  event = ["TextYankPost"];
                  desc = "Highlight when yanking (copying) text";
                  group = "kickstart-highlight-yank";
                  callback = lib.generators.mkLuaInline ''function() vim.hl.on_yank() end'';
                }
              ];
              diagnostics.config = {
                update_in_insert = false;
                severity_sort = true;
                float = "border:rounded, source:if_many";
                # underline = "severity:min:vim.diagnostic.severity.WARN";
                virtual_text = true;
                virtual_lines = false;
                jump = "float:true";
              };
              luaConfigRC.post = ''
                require('which-key').add({
                  { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
                  { "<leader>sv", group = "Telescope Git", mode = { "n", "v" } },
                  { "<leader>svc", group = "Commits", mode = { "n", "v" } },
                  -- { "<leader>t", group = "[T]oggle" },
                  -- { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
                })
              '';
            };
          }
        ];
      }).neovim;
  };
  flake.nixosModules.programs = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvf
    ];
  };
}
