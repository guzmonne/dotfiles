-- Venom configuration --
-- Disable vim-plugin according to documentation
local is_venom_installed, venom = pcall(require, "venom")

if not is_venom_installed then return end

venom.setup()

