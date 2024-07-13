-- Function to get traffic density based on player count
local function getTrafficDensity(playerCount)
    local scale = playerCount / Config.MaxPlayers
    return Config.MaxTrafficDensity - (scale * (Config.MaxTrafficDensity - Config.MinTrafficDensity))
end

-- Seatbelt status tracking
local seatbeltStatus = {}

-- Function to toggle seatbelt
local function toggleSeatbelt()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local seat = -2
        for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
            if GetPedInVehicleSeat(vehicle, i) == playerPed then
                seat = i
                break
            end
        end
        if seatbeltStatus[seat] then
            SetPedConfigFlag(playerPed, 32, false) -- Seatbelt off
            seatbeltStatus[seat] = false
            TriggerEvent('chat:addMessage', { args = { '^1Seatbelt', 'Seatbelt off' } })
            if Config.Debug then print("Seatbelt off") end
        else
            SetPedConfigFlag(playerPed, 32, true) -- Seatbelt on
            seatbeltStatus[seat] = true
            TriggerEvent('chat:addMessage', { args = { '^2Seatbelt', 'Seatbelt on' } })
            if Config.Debug then print("Seatbelt on") end
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
            if Config.Debug then
                print(string.format("Traffic density updated. Player count: %d, Density: %f", playerCount, density))
            end
        end
        Citizen.Wait(1000)
    end
end)

-- Enable or disable dispatch services
Citizen.CreateThread(function()
    local dispatchTypes = {
        "PoliceAutomobile",
        "PoliceHelicopter",
        "FireDepartment",
        "SwatAutomobile",
        "AmbulanceDepartment",
        "PoliceRiders",
        "PoliceVehicleRequest",
        "PoliceRoadBlock",
        "PoliceAutomobileWaitPulledOver",
        "PoliceAutomobileWaitCruising",
        "Gangs",
        "SwatHelicopter",
        "PoliceBoat",
        "ArmyVehicle",
        "BikerBackup"
    }

    for i, service in ipairs(dispatchTypes) do
        EnableDispatchService(i, Config.DispatchServices[service])
        if Config.Debug then
            print(string.format("Dispatch service %s set to %s", service, tostring(Config.DispatchServices[service])))
        end
    end
end)

-- Enable or disable boats
Citizen.CreateThread(function()
    while true do
        SetRandomBoats(Config.EnableBoats)
        if Config.Debug then print(string.format("Boats enabled: %s", tostring(Config.EnableBoats))) end
        Citizen.Wait(5000)
    end
end)

-- Enable or disable trains
Citizen.CreateThread(function()
    while true do
        SwitchTrainTrack(0, Config.EnableTrains)
        SetRandomTrains(Config.EnableTrains)
        if Config.Debug then print(string.format("Trains enabled: %s", tostring(Config.EnableTrains))) end
        Citizen.Wait(5000)
    end
end)

-- Enable or disable garbage trucks
Citizen.CreateThread(function()
    while true do
        if Config.EnableGarbageTrucks then
            RequestScriptAudioBank("SCRIPTED_SCANNER_REPORT_SUSPICIOUS_ACTIVITY_1", false, -1)
            if Config.Debug then print("Garbage trucks enabled") end
        else
            ReleaseScriptAudioBank("SCRIPTED_SCANNER_REPORT_SUSPICIOUS_ACTIVITY_1")
            if Config.Debug then print("Garbage trucks disabled") end
        end
        Citizen.Wait(5000)
    end
end)

-- Automatic Seatbelts
AddEventHandler('playerEnteredVehicle', function(vehicle, seat)
    if Config.AutoSeatbeltOnEntry then
        SetPedConfigFlag(PlayerPedId(), 32, true) -- Seatbelt on
        seatbeltStatus[seat] = true
        if Config.Debug then print("Automatic seatbelt engaged") end
    end
end)

-- Manual Seatbelts
Citizen.CreateThread(function()
    while true do
        if IsControlJustReleased(0, Config.SeatbeltKey) then
            toggleSeatbelt()
        end
        Citizen.Wait(10)
    end
end)

-- Speed Limiter
Citizen.CreateThread(function()
    while true do
        if Config.SpeedLimiterEnabled then
            local playerPed = PlayerPedId()
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

                if Config.Debug then print(string.format("Speed limiter set to %f m/s", speedLimit)) end
            end
        end
        Citizen.Wait(1000)
    end
end)

-- Disable vehicle weapons
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if DoesEntityExist(vehicle) then
            for _, weapon in ipairs({
                "WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_SMG", "WEAPON_MICROSMG",
                "WEAPON_ASSAULTSMG", "WEAPON_MINISMG", "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_COMBATMG_MK2",
                "WEAPON_RPG", "WEAPON_GRENADELAUNCHER", "WEAPON_MINIGUN", "WEAPON_RAILGUN", "WEAPON_HOMINGLAUNCHER",
                "WEAPON_COMPACTLAUNCHER"
            }) do
                DisableVehicleWeapon(true, GetHashKey(weapon), vehicle, playerPed)
            end
            if Config.Debug then print("Vehicle weapons disabled") end
        end
        Citizen.Wait(1000)
    end
end)

-- NPC Driving Style
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle ~= 0 then
            local driver = GetPedInVehicleSeat(vehicle, -1)
            if driver ~= 0 and not IsPedAPlayer(driver) then
                SetDriveTaskDrivingStyle(driver, Config.MentalState.DrivingStyle)
                if Config.Debug then print(string.format("NPC driving style set to %d", Config.MentalState.DrivingStyle)) end
            end
        end
        Citizen.Wait(2000)
    end
end)

-- Realistic Vehicle Damage System
Citizen.CreateThread(function()
    local tirePopped = {}
    local explosionTriggered = false
    local wheelFallOffTriggered = {}

    while true do
        Citizen.Wait(500)

        if Config.DamageSystem.enabled then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                if GetPedInVehicleSeat(vehicle, -1) == ped then
                    local healthEngineCurrent = GetVehicleEngineHealth(vehicle)
                    local healthBodyCurrent = GetVehicleBodyHealth(vehicle)
                    local healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)

                    local deformationDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult')
                    local collisionDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult')
                    local engineDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult')

                    deformationDamageMult = deformationDamageMult * Config.DamageSystem.deformationMultiplier
                    collisionDamageMult = collisionDamageMult * Config.DamageSystem.collisionDamageExponent
                    engineDamageMult = engineDamageMult * Config.DamageSystem.engineDamageExponent

                    local healthEngineNew = healthEngineCurrent
                    if healthEngineCurrent < Config.DamageSystem.cascadingFailureThreshold then
                        healthEngineNew = healthEngineNew - (0.1 * Config.DamageSystem.cascadingFailureSpeedFactor)
                    elseif healthEngineCurrent < Config.DamageSystem.degradingFailureThreshold then
                        healthEngineNew = healthEngineNew - (0.038 * Config.DamageSystem.degradingFailureSpeedFactor)
                    end

                    if healthEngineNew < Config.DamageSystem.engineSafeGuard then
                        healthEngineNew = Config.DamageSystem.engineSafeGuard
                    end

                    if Config.DamageSystem.engineExplosion.enabled and healthEngineNew < Config.DamageSystem.engineExplosion.threshold and not explosionTriggered then
                        AddExplosion(GetEntityCoords(vehicle).x, GetEntityCoords(vehicle).y, GetEntityCoords(vehicle).z, 7, 0.0, true, false, 1.0)
                        print("Explosion Triggered")
                        DetachVehicleWindscreen(vehicle)
                        explosionTriggered = true
                        if Config.Debug then print("Engine explosion triggered") end
                    end

                    if healthBodyCurrent < Config.DamageSystem.wheelFallOff.bodyHealthThreshold and not wheelFallOffTriggered[vehicle] then
                        wheelFallOffTriggered[vehicle] = true
                        for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
                            if math.random() < Config.DamageSystem.wheelFallOff.probability then
                                BreakOffVehicleWheel(vehicle, i, true, false, true, false)
                                print(string.format("Wheel %d broke off", i))
                                if Config.Debug then print(string.format("Wheel %d fell off", i)) end
                            end
                        end
                    end

                    if Config.DamageSystem.flatTire.enabled then
                        for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
                            if not tirePopped[vehicle] then tirePopped[vehicle] = {} end
                            if not tirePopped[vehicle][i] and math.random() < Config.DamageSystem.flatTire.probability then
                                SetVehicleTyreBurst(vehicle, i, true, 1000.0)
                                tirePopped[vehicle][i] = true
                                if Config.Debug then print(string.format("Tire %d popped", i)) end
                            end
                        end
                    end

                    SetVehicleEngineHealth(vehicle, healthEngineNew)
                    if Config.Debug then print(string.format("Applied new engine health: %f", healthEngineNew)) end
                end
            end
        end
    end
end)

-- Debug prints for wheel health and vehicle health
Citizen.CreateThread(function()
    while true do
        if Config.Debug then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local healthEngine = GetVehicleEngineHealth(vehicle)
                local healthBody = GetVehicleBodyHealth(vehicle)
                local healthPetrolTank = GetVehiclePetrolTankHealth(vehicle)
                print(string.format("Engine Health: %f", healthEngine))
                print(string.format("Body Health: %f", healthBody))
                print(string.format("Petrol Tank Health: %f", healthPetrolTank))
                for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
                    local wheelHealth = GetVehicleWheelHealth(vehicle, i)
                    local tireWear = GetTyreWearMultiplier(vehicle, i)
                    print(string.format("Wheel %d Health: %f", i, wheelHealth))
                    print(string.format("Wheel %d Wear: %f", i, tireWear))
                end
            end
        end
        Citizen.Wait(5000)
    end
end)

-- Keep engine running when player carjacks NPC
Citizen.CreateThread(function()
    while true do
        if Config.AllowStealNPCCars then
            local playerPed = PlayerPedId()
            if IsPedJacking(playerPed) then
                local targetVehicle = GetVehiclePedIsTryingToEnter(playerPed)
                if DoesEntityExist(targetVehicle) and not IsVehicleSeatFree(targetVehicle, -1) then
                    local targetPed = GetPedInVehicleSeat(targetVehicle, -1)
                    if not IsPedAPlayer(targetPed) then
                        TaskLeaveVehicle(targetPed, targetVehicle, 16)
                        Citizen.Wait(500)
                        TaskWarpPedIntoVehicle(playerPed, targetVehicle, -1)
                        SetVehicleEngineOn(targetVehicle, true, true, false)
                        if Config.Debug then print("Player carjacked NPC vehicle") end
                    end
                end
            end
        end
        Citizen.Wait(100)
    end
end)

-- Exported function to change NPC driving style
function ChangeNPCDrivingStyle(drivingStyle)
    Config.MentalState.DrivingStyle = drivingStyle
    if Config.Debug then print(string.format("NPC driving style changed to %d", drivingStyle)) end
end

exports('ChangeNPCDrivingStyle', ChangeNPCDrivingStyle)
