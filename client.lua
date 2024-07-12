-- Load configuration
local Config = Config or {}

local function getTrafficDensity(playerCount)
    local scale = (playerCount / Config.MaxPlayers)
    return Config.MaxTrafficDensity - (scale * (Config.MaxTrafficDensity - Config.MinTrafficDensity))
end

local seatbeltStatus = {}

local function toggleSeatbelt()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local seat = GetPedVehicleSeat(playerPed)
        if seatbeltStatus[seat] then
            SetPedConfigFlag(playerPed, 32, false) -- Seatbelt off
            seatbeltStatus[seat] = false
            TriggerEvent('chat:addMessage', { args = { '^1Seatbelt', 'Seatbelt off' } })
        else
            SetPedConfigFlag(playerPed, 32, true) -- Seatbelt on
            seatbeltStatus[seat] = true
            TriggerEvent('chat:addMessage', { args = { '^2Seatbelt', 'Seatbelt on' } })
        end
    end
end

-- Dynamic Traffic Management
Citizen.CreateThread(function()
    while true do
        if Config.DynamicTrafficManagement then
            local playerCount = #GetActivePlayers()
            local density = getTrafficDensity(playerCount)
            SetParkedVehicleDensityMultiplierThisFrame(density * (Config.ParkedAmount / 100.0))
            SetVehicleDensityMultiplierThisFrame(density * (Config.TrafficAmount / 100.0))
            SetRandomVehicleDensityMultiplierThisFrame(density * (Config.TrafficAmount / 100.0))
            SetPedDensityMultiplierThisFrame(density * (Config.PedestrianAmount / 100.0))
        end
        Citizen.Wait(1000)
    end
end)

-- Enable or disable dispatch services
Citizen.CreateThread(function()
    for i = 1, 15 do
        EnableDispatchService(i, Config.EnableDispatch)
    end
end)

-- Enable or disable boats
Citizen.CreateThread(function()
    while true do
        SetBoatDensityMultiplierThisFrame(Config.EnableBoats and 1.0 or 0.0)
        Citizen.Wait(1000)
    end
end)

-- Enable or disable trains
Citizen.CreateThread(function()
    while true do
        SwitchTrainTrack(0, Config.EnableTrains)
        SetRandomTrains(Config.EnableTrains)
        Citizen.Wait(1000)
    end
end)

-- Enable or disable garbage trucks
Citizen.CreateThread(function()
    while true do
        if Config.EnableGarbageTrucks then
            RequestScriptAudioBank("SCRIPTED_SCANNER_REPORT_SUSPICIOUS_ACTIVITY_1", false, -1)
        else
            ReleaseScriptAudioBank("SCRIPTED_SCANNER_REPORT_SUSPICIOUS_ACTIVITY_1")
        end
        Citizen.Wait(1000)
    end
end)

-- Automatic Seatbelts
AddEventHandler('playerEnteredVehicle', function(vehicle, seat)
    if Config.AutoSeatbeltOnEntry then
        SetPedConfigFlag(GetPlayerPed(-1), 32, true) -- Seatbelt on
        seatbeltStatus[seat] = true
    end
end)

-- Manual Seatbelts
Citizen.CreateThread(function()
    while true do
        if IsControlJustReleased(0, Config.SeatbeltKey) then
            toggleSeatbelt()
        end
        Citizen.Wait(0)
    end
end)

-- Speed Limiter
Citizen.CreateThread(function()
    while true do
        if Config.SpeedLimiterEnabled then
            local playerPed = GetPlayerPed(-1)
            if IsPedInAnyVehicle(playerPed, false) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                local speedLimit = Config.GlobalSpeedLimit / 3.6 -- Converting km/h to m/s
                local playerCoords = GetEntityCoords(playerPed)

                for _, zone in ipairs(Config.SpeedZones) do
                    if #(playerCoords - zone.coords) < zone.radius then
                        speedLimit = zone.speed / 3.6
                        break
                    end
                end

                if GetEntitySpeed(vehicle) > speedLimit then
                    SetVehicleMaxSpeed(vehicle, speedLimit)
                else
                    SetVehicleMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel"))
                end
            end
        end
        Citizen.Wait(500)
    end
end)

-- Disable vehicle weapons
Citizen.CreateThread(function()
    while true do
        if Config.DisableVehicleWeapons then
            local playerPed = GetPlayerPed(-1)
            if IsPedInAnyVehicle(playerPed, false) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                SetVehicleWeaponDisabled(vehicle, true)
            end
        end
        Citizen.Wait(1000)
    end
end)

-- NPC Driving Style
Citizen.CreateThread(function()
    while true do
        local playerPed = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle ~= 0 then
            local driver = GetPedInVehicleSeat(vehicle, -1)
            if driver ~= 0 and not IsPedAPlayer(driver) then
                SetDriveTaskDrivingStyle(driver, Config.MentalState.DrivingStyle)
            end
        end
        Citizen.Wait(1000)
    end
end)
