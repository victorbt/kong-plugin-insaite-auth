return {
  no_consumer = false, -- this plugin is available on APIs as well as on Consumers,
  no_consumer = true, -- this plugin is available only on APIs
  fields = {
    -- Describe your plugin's configuration's schema here.

    url = {required = true, type = "string"},
    response = { required = true, default = "table", type = "string", enum = {"table"}},
    timeout = { default = 10000, type = "number" },
    keepalive = { default = 60000, type = "number" }
  },
}