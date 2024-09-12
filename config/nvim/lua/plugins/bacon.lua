return {
  "Canop/nvim-bacon",
  opts = {
    quickfix = {
      enabled = true, -- true to populate the quickfix list with bacon errors and warnings
      event_trigger = true, -- triggers the QuickFixCmdPost event after populating the quickfix list
    },
  },
}
