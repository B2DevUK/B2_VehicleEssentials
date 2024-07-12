# b2_vehicleEssentials

`b2_vehicleEssentials` is a FiveM script providing essential vehicle management features including dynamic traffic management, automatic seatbelts, configurable speed limit zones, and more.

## Features

- **Dynamic Traffic Management**: Adjusts traffic density based on the number of players online.
- **Automatic Seatbelts**: Automatically applies seatbelts when entering a vehicle.
- **Speed Limiter**: Configurable speed limit zones and a global speed limiter.
- **Configurable Traffic, Pedestrians, and Parked Vehicles**: Adjust the amount of traffic, pedestrians, and parked vehicles.
- **Enable/Disable Various Services**: Dispatch services, boats, trains, and garbage trucks.
- **Disable Vehicle Weapons**: Prevents vehicles from giving weapons to players when they get in.
- **NPC Driving Style**: Configurable driving styles for NPCs.

## Installation

1. Download the resource.
2. Place the `b2_vehicleEssentials` folder in your `resources` directory.
3. Add `start b2_vehicleEssentials` to your `server.cfg`.

## Configuration

Edit the `config.lua` file to customize the settings:

```lua
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

```

### Driving Style Options

You can set different driving styles for NPCs using the following flags in the `Config.MentalState.DrivingStyle` option:

- **786603**: Normal driving (default behavior)
- **1074528293**: Normal driving but avoiding obstacles more aggressively
- **2883621**: Fast and aggressive driving
- **6**: Very cautious driving
- **1076**: Sometimes stop before junctions, drive normally otherwise
- **7**: Ignore all traffic lights and drive normally
- **16777216**: Follow traffic laws strictly
- **536871299**: Very careful, stops a lot
- **536871044**: Reverse with care
- **536871045**: Reverse very carefully
- **536870912**: Very slow driving, usually used for non-road vehicles
- **536871356**: Use paths only (no roads)
- **16777215**: A combination of cautious and aggressive

## Usage

The script runs automatically based on the configurations set in `config.lua`. Adjust settings to fit your server's needs.

### Dynamic Traffic Management

- The traffic density dynamically adjusts based on the number of players online.
- Set `Config.DynamicTrafficManagement` to `true` to enable this feature.

### Automatic Seatbelts

- Automatically applies seatbelts when the player enters a vehicle.
- Set `Config.AutoSeatbeltOnEntry` to `true` to enable this feature.

### Manual Seatbelts

- Toggle seatbelts manually using a customizable keybind.
- Set the keybind using `Config.SeatbeltKey`.

### Speed Limiter

- Configure global and zone-specific speed limits.
- Global speed limit is set via `Config.GlobalSpeedLimit`.
- Zone-specific speed limits are set via `Config.SpeedZones` array.

### Traffic, Pedestrians, and Parked Vehicles

- Adjust the amount of traffic, pedestrians, and parked vehicles by setting `Config.TrafficAmount`, `Config.PedestrianAmount`, and `Config.ParkedAmount`.

### Enable/Disable Services

- Enable or disable dispatch services, boats, trains, and garbage trucks via `Config.EnableDispatch`, `Config.EnableBoats`, `Config.EnableTrains`, and `Config.EnableGarbageTrucks`.

### Disable Vehicle Weapons

- Prevent vehicles from giving weapons to players by setting `Config.DisableVehicleWeapons` to `true`.

### NPC Driving Style

- Configure NPC driving styles using `Config.MentalState.DrivingStyle`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please submit pull requests or open issues to improve the script.

## Acknowledgements

- [FiveM](https://fivem.net/) for providing the platform.
- All contributors to this project.

Enjoy the resource and happy driving!