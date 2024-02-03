-- script mpv to fetch http://localhost:9789/playing-url then copy it to clipboard. Assign key is "c'

local utils = require 'mp.utils'
local msg = require 'mp.msg'

function fetchURL()
    local apiURL = "http://localhost:9789/playing-url"
    local result, err = utils.subprocess({args = {"curl", "--tlsv1.2", apiURL}})
    if result.error or result.status ~= 0 then
        msg.error("Failed to fetch URL: " .. (err or ""))
        return
    end
    local url = result.stdout:gsub("\n", "")
    mp.set_property("options/vo-config", "window-scale=0.5")
    mp.osd_message("URL copied to clipboard: " .. url)
    os.execute("echo " .. url .. " | xclip -selection clipboard")
end

mp.add_key_binding("c", "fetch_and_copy_url", fetchURL)
