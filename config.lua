Config = {}

-- Dynamic Traffic Management
Config.DynamicTrafficManagement = true
Config.MaxTrafficDensity = 0.5 -- Base density when no players are online
Config.MinTrafficDensity = 0.1 -- Minimum density when maximum players are online
Config.MaxPlayers = 32 -- Maximum number of players expected on the server

Config.TrafficAmount = 100
Config.PedestrianAmount = 100
Config.ParkedAmount = 100
Config.EnableDispatch = true
Config.EnableBoats = true
Config.EnableTrains = true
Config.EnableGarbageTrucks = true

-- Automatic Seatbelts
Config.AutoSeatbeltOnEntry = true

-- Speed Limiter
Config.SpeedLimiterEnabled = true
Config.GlobalSpeedLimit = 120.0 -- Speed in km/h

Config.SpeedZones = {
    { coords = vector3(215.0, -810.0, 30.0), radius = 50.0, speed = 50.0 }, -- Example zone
    { coords = vector3(-500.0, -200.0, 35.0), radius = 100.0, speed = 80.0 } -- Another example zone
}