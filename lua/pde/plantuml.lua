if not require('config').pde.plantuml then
  return {}
end

return {
  {
    'https://gitlab.com/itaranto/plantuml.nvim',
    event = 'VeryLazy',
    version = '*',
    config = function()
      require('plantuml').setup {
        renderer = {
          type = 'image',
          options = {
            prog = 'feh',
            dark_mode = false,
            format = nil, -- Allowed values: nil, 'png', 'svg'.
          },
        },
        render_on_write = false,
      }

      vim.keymap.set('n', '<leader>ps', '<cmd>PlantUML<cr>', { silent = true, desc = 'Render PlantUML' })
    end,
  },
}
