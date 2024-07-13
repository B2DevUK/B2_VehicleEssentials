# b2_vehicleEssentials v1.1.0

A comprehensive FiveM script for vehicle management including dynamic traffic control, automatic and manual seatbelts, speed limiters, realistic vehicle damage, and more.

## Features

- **Dynamic Traffic Management**: Adjust traffic and pedestrian density based on server population.
- **Automatic Seatbelts**: Automatically apply seatbelts when entering a vehicle.
- **Manual Seatbelts**: Toggle seatbelt manually with a configurable keybind.
- **Speed Limiter**: Set global and zone-specific speed limits.
- **Realistic Vehicle Damage**: Advanced vehicle damage system including engine explosions, wheel fall-offs, and tire punctures.
- **NPC Driving Style**: Configure NPC driving styles.
- **Disable Vehicle Weapons**: Prevent vehicles from giving weapons to players.
- **Steal NPC Cars**: Allows players to steal NPC cars with the engine running.
- **Debug Mode**: Provides detailed debug information for developers.

## Installation

1. Download the script and place it in your `resources` folder.
2. Add `start b2_vehicleEssentials` to your `server.cfg`.

## Configuration

Edit the `config.lua` file to customize the script to your server's needs.

### Example `config.lua`

```lua
Config = {}

-- Debug mode
Config.Debug = true -- Toggle debug mode

-- Dynamic Traffic Management
Config.DynamicTrafficManagement = true
Config.MaxTrafficDensity = 0.5 -- Base density when no players are online
Config.MinTrafficDensity = 0.1 -- Minimum density when maximum players are online
Config.MaxPlayers = 32 -- Maximum number of players expected on the server

Config.TrafficAmount = 100
Config.PedestrianAmount = 100
Config.ParkedAmount = 100
Config.EnableBoats = true
Config.EnableTrains = true
Config.EnableGarbageTrucks = true

-- Automatic Seatbelts
Config.AutoSeatbeltOnEntry = true

-- Manual Seatbelts
Config.SeatbeltKey = 303 -- U key (changeable)

-- Speed Limiter
Config.SpeedLimiterEnabled = true
Config.GlobalSpeedLimit = 120.0 -- Speed in km/h

Config.SpeedZones = {
    { coords = vector3(215.0, -810.0, 30.0), radius = 50.0, speed = 50.0 }, -- Example zone
    { coords = vector3(-500.0, -200.0, 35.0), radius = 100.0, speed = 80.0 } -- Another example zone
}

-- NPC Driving Style
Config.MentalState = {
    DrivingStyle = 786603 -- Default style; can be changed
}

-- Disable vehicle weapons
Config.DisableVehicleWeapons = true

-- Enable or disable specific dispatch services
Config.DispatchServices = {
    PoliceAutomobile = true,
    PoliceHelicopter = true,
    FireDepartment = true,
    SwatAutomobile = true,
    AmbulanceDepartment = true,
    PoliceRiders = true,
    PoliceVehicleRequest = true,
    PoliceRoadBlock = true,
    PoliceAutomobileWaitPulledOver = true,
    PoliceAutomobileWaitCruising = true,
    Gangs = true,
    SwatHelicopter = true,
    PoliceBoat = true,
    ArmyVehicle = true,
    BikerBackup = true
}

-- Realistic Vehicle Damage System
Config.DamageSystem = {
    enabled = true, -- Toggle entire damage system
    deformationMultiplier = 2.0, -- increased deformation damage
    collisionDamageExponent = 1.5, -- increased collision damage
    engineDamageExponent = 2.0, -- increased engine damage
    cascadingFailureSpeedFactor = 15.0, -- increased cascading failure speed
    degradingFailureSpeedFactor = 3.0, -- increased degrading failure speed
    degradingFailureThreshold = 500.0, -- Threshold for degrading failure
    cascadingFailureThreshold = 250.0, -- Threshold for cascading failure
    engineSafeGuard = 50.0, -- Safeguard value for engine
    compatibilityMode = false,
    engineExplosion = {
        enabled = true,
        threshold = 100.0 -- Threshold for engine explosion
    },
    wheelFallOff = {
        enabled = true,
        bodyHealthThreshold = 900.0, -- Threshold for body health below which wheels may fall off
        probability = 0.25 -- Probability that a wheel will fall off when the threshold is met
    },
    flatTire = {
        enabled = true,
        probability = 0.0001 -- Probability of random flat tires
    },
    collisionDamage = {
        enabled = true,
        multiplier = 2.0 -- increased collision damage multiplier
    },
    deformationDamage = {
        enabled = true,
        multiplier = 2.0 -- increased deformation damage multiplier
    },
    engineDamage = {
        enabled = true,
        multiplier = 2.0 -- increased engine damage multiplier
    },
    bodyDamage = {
        enabled = true,
        multiplier = 2.0 -- increased body damage multiplier
    },
    petrolTankDamage = {
        enabled = true,
        multiplier = 2.0 -- increased petrol tank damage multiplier
    },
}

-- Allow players to steal NPC cars
Config.AllowStealNPCCars = true
```

## Usage

- **Toggle Seatbelt**: Press the configured key (`U` by default) to toggle the seatbelt.
- **Monitor Traffic**: The script will automatically adjust traffic based on the number of players online.
- **Realistic Damage**: Experience enhanced vehicle damage with explosions, wheel fall-offs, and tire punctures.
- **Steal NPC Cars**: Carjack NPCs and drive away with the engine running.

## Development

For development and debugging, set `Config.Debug` to `true` to enable detailed debug prints.

## License

This project is licensed under the MIT License.
