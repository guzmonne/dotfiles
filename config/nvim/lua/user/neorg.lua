-- NConf configuration --
require("neorg").setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    work = "~/.notes/work",
                    quick = "~/.notes/quick",
                    home = "~/.notes/home",
                }
            }
        },
        ["core.keybinds"] = {
            config = {
                default_keybinds = false,
            }
        }
    }
}
