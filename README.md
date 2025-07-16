# I Wanna Be The Engine (IWBTE) - Godot 4

🤖 **A complete game engine for creating "I Wanna Be The Guy" style games in Godot 4.4**

[![Godot](https://img.shields.io/badge/Godot-4.4-blue.svg)](https://godotengine.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## About

This engine provides a solid foundation for creating notoriously difficult precision platformer games in the style of ["I Wanna Be The Guy"](https://kayin.itch.io/iwbtg). It includes all the essential mechanics, systems, and features needed to build challenging platformer experiences.

## Features

### 🎮 Core Gameplay Mechanics
- **Precise Movement**: Smooth character movement with customizable speed
- **Jumping System**: Standard jump + air jump (double jump) with different forces
- **Wall Jumping**: Wall slide mechanics with reduced gravity
- **Shooting**: Bullet projectiles that can trigger save points
- **Death & Respawn**: Instant death mechanics with blood effects (optional)
- **Save System**: Multiple save slots with position and room persistence

### 🏗️ Level Building Components
- **Blocks/Platforms**: Solid collision blocks with multiple tile variants
- **Spikes**: Deadly spike traps with collision detection
- **Save Points**: Bullet-activated checkpoint system
- **Wall Jump Areas**: Configurable wall-slide zones
- **Room System**: 800x608 resolution rooms with seamless transitions

### 🎵 Audio & Visual
- **Sound Effects**: Jump, double jump, shooting, death, UI interactions
- **Music System**: Background music with separate audio buses
- **Visual Effects**: Blood particle system on death
- **Animations**: Idle, walking, jumping, falling, wall sliding
- **UI Themes**: Consistent styling across menus and HUD

### 💾 Game Management
- **Save System**: JSON-based save files with multiple slots
- **Menu System**: Main menu, load game, pause functionality
- **HUD**: In-game overlay with pause and menu options
- **Game Over**: Death state management with restart options
- **Settings**: Blood effects toggle, volume controls

### ⚙️ Technical Features
- **Global State Management**: Centralized game state through `Env.gd`
- **Input System**: Configurable controls with keyboard support
- **Scene Management**: Modular room-based scene structure
- **Asset Organization**: Structured folders for sprites, sounds, scripts
- **Collision Layers**: Proper separation between player, threats, and environment

## Installation & Setup

### Prerequisites
- Godot 4.4 or later
- Basic knowledge of Godot and GDScript

### Quick Start
1. Clone or download this repository
2. Open the project in Godot 4.4+
3. Run the project - it will start with the main menu
4. Play the demo level to test all mechanics

### Project Structure
```
iwbte-godot/
├── Objects/           # Game objects and prefabs
│   ├── Player/       # Player character and related components
│   ├── Blocks.tscn   # Platform/block tilemap
│   ├── Spike.tscn    # Individual spike trap
│   └── Save.res      # Save point object
├── Rooms/            # Game levels and UI scenes
│   ├── GamePlay/     # Game levels
│   └── Menu/         # Menu screens and HUD
├── Scripts/          # All GDScript files
│   ├── Player.gd     # Main player controller
│   ├── Menu/         # Menu system scripts
│   └── [Other mechanics]
├── Sprites/          # All visual assets
├── Sounds/           # Audio files (SFX & Music)
└── Fonts/            # UI fonts and icons
```

## Controls

### Default Controls
- **Arrow Keys**: Move left/right
- **Space/Up Arrow**: Jump (double jump in air)
- **Z**: Shoot
- **R**: Restart current room
- **K**: Kill player (for testing)
- **ESC**: Return to main menu

### Gameplay Mechanics
- **Wall Jumping**: Hold jump while against a wall to slide and wall jump
- **Save Points**: Shoot save points to create checkpoints
- **Death**: Touching spikes or threats instantly kills the player
- **Respawn**: Players respawn at the last activated save point

## Creating Your Own Levels

### Room Creation
1. Create a new scene inheriting from `Node2D`
2. Add the required components:
   - `PlayerStart.tscn` - Player spawn point
   - `HUD.tscn` - UI overlay
   - Level geometry using `Blocks.tscn`
   - Threats using `Spike.tscn` or custom threats
   - Save points using `Save.res`

### Adding Threats
- Any object in the "Threats" group will kill the player on contact
- Use collision layer 8 for threat detection
- Spikes are pre-configured but you can create custom threats

### Save Points
- Place `Save.res` objects where you want checkpoints
- Players must shoot them to activate
- Save data includes player position and current room

### Wall Jump Areas
- Use `WallJump.res` objects to define wall-jumpable surfaces
- Configure `direction` property for left/right walls
- Multiple areas can be stacked for tall walls

## Customization

### Player Settings
Edit `Scripts/Player.gd` constants:
```gdscript
const GRAVITY = 980.0      # Gravity strength
const HSPEED = 140         # Horizontal movement speed
const JUMP_FORCE = 400     # Initial jump force
const DJUMP_FORCE = 330    # Double jump force
```

### Game Settings
Modify `Env.gd` for global settings:
- Blood effects toggle
- Volume controls
- Save slot management
- Room transitions

### Visual Customization
- Replace sprites in `Sprites/` folders
- Modify animations in `Objects/Player/Player.tscn`
- Update UI themes in `Rooms/Menu/UI/`

## Audio System

### Sound Effects
- Jump/Double Jump sounds
- Shooting sound
- Death music
- UI interaction sounds

### Music
- Background music system with looping
- Separate audio buses for Music and SFX
- Volume controls in settings

## Save System

### Features
- Multiple save slots support
- Automatic position saving
- Room transition persistence
- JSON-based save files stored in user directory

### Save Data Structure
```gdscript
{
  "name": "Player Name",
  "position": {"x": 100, "y": 200},
  "room": "roomStart",
  "retries": 0,
  "difficulty": 0,
  "defeated": {...},
  "items": [...]
}
```

## Contributing

This engine is designed to be easily extensible. Common additions:
- New trap types
- Power-ups and items
- Boss enemies
- Additional movement mechanics
- Visual effects
- Audio improvements

## Credits

- Original "I Wanna Be The Guy" by [Kayin](https://kayin.itch.io/iwbtg)
- Engine inspired by [iwbte-godot](https://github.com/vstyler96/iwbte-godot)
- Built with [Godot Engine](https://godotengine.org/)

## License

This project is open source. Please check the LICENSE file for details.

---

**Ready to create your own impossible platformer? Start building with IWBTE for Godot!** 🚀 