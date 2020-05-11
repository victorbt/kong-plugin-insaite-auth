local typedefs = require "kong.db.schema.typedefs"

-- Grab pluginname from module name
local plugin_name = "insaite-auth"

local schema = {
  name = plugin_name,
  fields = {
    url = {required = true, type = "string"},
    response = { required = true, default = "table", type = "string", enum = {"table", "string"}},
    timeout = { default = 10000, type = "number" },
    keepalive = { default = 60000, type = "number" }
    },
  },
}

-- run_on_first typedef/field was removed in Kong 2.x
-- try to insert it, but simply ignore if it fails
pcall(function()
        table.insert(schema.fields, { run_on = typedefs.run_on_first })
      end)

return schema
