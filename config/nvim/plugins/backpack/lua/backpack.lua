local M = {}

-- Set the opt folder where the plugins will be symlinked to.
local opt = vim.fn.stdpath('data')..'/site/pack/backpack/opt'
-- Set the path where the plugins source lives.
local plugins = vim.fn.stdpath('config')..'/plugins'
-- Set the path to the manifest file.
local manifest = vim.fn.stdpath('config')..'/packmanifest.lua'

function M.setup()
  -- Make sure the `opt` folder exists.
  vim.fn.mkdir(opt, 'p')

  M.plugins = {}
  -- 'use' will be defined only for use in the manifest.
  _G.use = function(opts)
    local _, _, plugin = string.find(opts[1], '^([^ /]+)$')
    -- Track the plugin so it can be updated with :GuxBackpackUpdate.
    table.insert(M.plugins, {
      plugin = plugin,
    })

    local plugin_dir = opt..'/'..plugin

    -- Create the plugin directory.
    vim.fn.mkdir(plugin_dir, 'p')
    -- Run stow to symlink the plugin to the `opt` directory.
    vim.loop.spawn('stow', {
      args = { '-R', '-t', plugin_dir, plugin },
      cwd = plugins,
    }, vim.schedule_wrap(function(code)
        if code == 0 then
          vim.cmd('packadd! '..plugin)
          vim.api.nvim_out_write(string.format('%s', vim.inspect(plugin)))
        else
          vim.api.nvim_err_writeln(string.format('Failed to run %s', vim.inpspect(plugin)))
        end
      end)
    )
  end

  if vim.fn.filereadable(manifest) ~= 0 then
    dofile(manifest)
  end
  _G.use = nil
end

return M
