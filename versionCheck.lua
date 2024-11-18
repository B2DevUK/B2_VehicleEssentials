local currentVersion = "1.2.0"
-- GITHUB VERSION CHECK
function fetchLatestVersion(callback)
    PerformHttpRequest("https://api.github.com/repos/B2DevUK/B2_VehicleEssentials/releases/latest", function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            if data and data.tag_name then
                callback(data.tag_name)
            else
                print("Failed to fetch the latest version")
            end
        else
            print("HTTP request failed with status code: " .. statusCode)
        end
    end, "GET")
end

function checkForUpdates()
    fetchLatestVersion(function(latestVersion)
        if currentVersion ~= latestVersion then
            print("A new version of the script is available!")
            print("Current version: " .. currentVersion)
            print("Latest version: " .. latestVersion)
            print("Please update the script from: https://github.com/B2DevUK/B2_VehicleEssentials")
        else
            print("Your script is up to date!")
        end
    end)
end

checkForUpdates()