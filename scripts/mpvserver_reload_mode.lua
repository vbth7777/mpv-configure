local mp = require("mp")
local utils = require("mp.utils")

function reload()
	local url = "http://localhost:9789/reload"
	mp.osd_message("Reloaded")
	local result, err = utils.subprocess({ args = { "curl", "-X", "POST", url } })
	if result.error or result.status ~= 0 then
		mp.msg.error("Failed to reload: " .. (err or ""))
		mp.osd_message("Failed to reload")
		return
	end
end

mp.add_key_binding(nil, "reload", reload)
