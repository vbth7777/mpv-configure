local utils = require 'mp.utils'

function openURLInBrowser(url)
    local chromeCommand = "google-chrome-stable"
    local result, err = utils.subprocess({args = {"pgrep", "-x", "google-chrome-stable"}})
    if result.error or result.status ~= 0 then
        mp.msg.error("Failed to check if google-chrome-stable is running: " .. (err or ""))
    else
        if result.stdout ~= "" then
            chromeCommand = "google-chrome-stable"
        end
    end
    local profileDirectory = "Default"
    local args = {chromeCommand, "--profile-directory=" .. profileDirectory, url}
    local result = utils.subprocess({args = args})

    if result.error == nil then
        mp.osd_message("Google Chrome stable launched successfully")
    else
        mp.osd_message("Failed to launch Google Chrome stable")
    end
end

function fetchAndOpenURL()
    local apiURL = "http://localhost:9789/playing-url"

    local result, err = utils.subprocess({args = {"curl", "--tlsv1.2", apiURL}})
    if result.error or result.status ~= 0 then
        mp.msg.error("Failed to fetch URL: " .. (err or ""))
        openURLInBrowser(mp.get_property("path"))
        return
    end

    local url = result.stdout:gsub("\n", "")

    openURLInBrowser(url)
end

mp.add_key_binding("b", "fetch_and_open_url", fetchAndOpenURL)
