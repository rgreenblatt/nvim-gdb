local log = require 'nvimgdb.log'

local C = {}
C.efmmgr = require 'nvimgdb.efmmgr'
C.__index = C

-- Create a new instance of the debugger in the current tabpage.
function C.new(backend_name, proxy_cmd, client_cmd)
  local self = setmetatable({}, C)

  self.config = require'nvimgdb.config'.new()

  -- Get the selected backend module
  self.backend = require "nvimgdb.backend".choose(backend_name)

  -- Go to the other window and spawn gdb client
  self.client = require'nvimgdb.client'.new(proxy_cmd, client_cmd)

  -- Initialize connection to the side channel
  self.proxy = require'nvimgdb.proxy'.new(self.client)

  -- Initialize the keymaps subsystem
  self.keymaps = require'nvimgdb.keymaps'.new(self.config)

  -- Initialize current line tracking
  self.cursor = require'nvimgdb.cursor'.new(self.config)

  -- Setup 'errorformat' for the given backend.
  C.efmmgr.setup(self.backend.get_error_formats())

  return self
end

-- Cleanup the current instance.
function C:cleanup()
  -- Remove from 'errorformat' for the given backend.
  C.efmmgr.teardown(self.backend.get_error_formats())

  -- Clean up the current line sign
  self.cursor:hide()

  -- Close connection to the side channel
  self.proxy:cleanup()

  -- Close the debugger backend
  self.client:cleanup()
end

return C