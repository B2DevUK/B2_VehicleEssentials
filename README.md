# b2_vehicleEssentials V1.1.0

## SUPPORT DISCORD: discord.gg/KZRBA6H5kR 

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
    deformationMultiplier = 2.0, -- Further increased deformation damage
    collisionDamageExponent = 1.5, -- Further increased collision damage
    engineDamageExponent = 2.0, -- Further increased engine damage
    cascadingFailureSpeedFactor = 15.0, -- Further increased cascading failure speed
    degradingFailureSpeedFactor = 3.0, -- Further increased degrading failure speed
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
        multiplier = 2.0 -- Further increased collision damage multiplier
    },
    deformationDamage = {
        enabled = true,
        multiplier = 2.0 -- Further increased deformation damage multiplier
    },
    engineDamage = {
        enabled = true,
        multiplier = 2.0 -- Further increased engine damage multiplier
    },
    bodyDamage = {
        enabled = true,
        multiplier = 2.0 -- Further increased body damage multiplier
    },
    petrolTankDamage = {
        enabled = true,
        multiplier = 2.0 -- Further increased petrol tank damage multiplier
    },
}

-- Allow players to steal NPC cars
Config.AllowStealNPCCars = true

```

## Usage

The script runs automatically based on the configurations set in `config.lua`. Adjust settings to fit your server's needs.

### Driving Style Options

You can set different driving styles for NPCs using the following flags in the `Config.MentalState.DrivingStyle` option:

- `786603`: Normal driving (default behavior)
- `1074528293`: Normal driving but avoiding obstacles more aggressively
- `2883621`: Fast and aggressive driving
- `6`: Very cautious driving
- `1076`: Sometimes stop before junctions, drive normally otherwise
- `7`: Ignore all traffic lights and drive normally
- `16777216`: Follow traffic laws strictly
- `536871299`: Very careful, stops a lot
- `536871044`: Reverse with care
- `536871045`: Reverse very carefully
- `536870912`: Very slow driving, usually used for non-road vehicles
- `536871356`: Use paths only (no roads)
- `16777215`: A combination of cautious and aggressive

### Features

- **Dynamic Traffic Management**: 
  - The traffic density dynamically adjusts based on the number of players online.
  - Set `Config.DynamicTrafficManagement` to `true` to enable this feature.

- **Automatic Seatbelts**: 
  - Automatically applies seatbelts when the player enters a vehicle.
  - Set `Config.AutoSeatbeltOnEntry` to `true` to enable this feature.

- **Manual Seatbelts**: 
  - Toggle seatbelts manually using a customizable keybind.
  - Set the keybind using `Config.SeatbeltKey`.

- **Speed Limiter**: 
  - Configure global and zone-specific speed limits.
  - Global speed limit is set via `Config.GlobalSpeedLimit`.
  - Zone-specific speed limits are set via `Config.SpeedZones` array.

- **Traffic, Pedestrians, and Parked Vehicles**: 
  - Adjust the amount of traffic, pedestrians, and parked vehicles by setting `Config.TrafficAmount`, `Config.PedestrianAmount`, and `Config.ParkedAmount`.

- **Enable/Disable Services**: 
  - Enable or disable dispatch services, boats, trains, and garbage trucks via `Config.EnableDispatch`, `Config.EnableBoats`, `Config.EnableTrains`, and `Config.EnableGarbageTrucks`.

- **Disable Vehicle Weapons**: 
  - Prevent vehicles from giving weapons to players by setting `Config.DisableVehicleWeapons` to `true`.

- **NPC Driving Style**: 
  - Configure NPC driving styles using `Config.MentalState.DrivingStyle`.

### Export Usage

To change the NPC driving style dynamically from other scripts, use the following export:

```lua
exports.b2_vehicleEssentials:ChangeNPCDrivingStyle(drivingStyle)
```

Example usage in another script:

```lua
-- Change NPC driving style to fast and aggressive
exports.b2_vehicleEssentials:ChangeNPCDrivingStyle(2883621)
```

## Development

For development and debugging, set `Config.Debug` to `true` to enable detailed debug prints.

## License

This project is licensed under the MIT License.
