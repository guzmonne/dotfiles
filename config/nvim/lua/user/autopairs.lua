-- autopairs --
require'nvim-autopairs'.setup {
    check_ts = true,
    ts_config = {lua = {"string", "source"}, javascript = {"string", "template_string"}},
    disable_filetype = {"TelescopePrompt", "spectre_panel"},
    fast_wrap = {
        map = "<S-e>",
        chars = {"{", "[", "(", '"', "'"},
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr"
    }
}
