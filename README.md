# I Wanna Be The Engine (IWBTE) - Godot 4.7

🤖 **A complete game engine for creating "I Wanna Be The Guy" style games in Godot 4.7**

[![Godot](https://img.shields.io/badge/Godot-4.7-blue.svg)](https://godotengine.org/)
[![License](https://img.shields.io/badge/license-AGPLv3.0-green.svg)](LICENSE)

## About

This engine provides a solid foundation for creating notoriously difficult precision platformer games in the style of ["I Wanna Be The Guy"](https://kayin.itch.io/iwbtg). It includes all the essential mechanics, systems, and features needed to build challenging platformer experiences.

## Features

### 🎮 Core Gameplay Mechanics
- **Precise Movement**: Smooth character movement with customizable speed
- **Jumping System**: Standard jump + air jump (double jump) with different forces
- **Wall Jumping**: Slow wall slide, jump on every press while touching a wall; each wall jump refreshes the double jump
- **Shooting**: Frame-rate independent bullets that hit enemies and trigger save points
- **Death & Respawn**: Instant death with a big blood splash (optional)
- **Save System**: Up to 3 encrypted save slots with random funny names

### 🏗️ Level Building Components
- **Blocks/Platforms**: Solid collision blocks with multiple tile variants
- **Spikes**: Deadly spike traps (TileMap based, plus a standalone spike)
- **Moving Spikes**: Spikes thrown up/down/left/right when the player enters a trigger, enabled per difficulty
- **Enemies**: Enemies with HP that blink when shot, throw cherries at the player and kill on touch
- **Save Points**: Bullet-activated checkpoint system
- **Wall Jump Areas**: Configurable wall-slide zones
- **Room System**: 800x608 resolution rooms with seamless transitions

### 🎵 Audio & Visual
- **Sound Effects**: Jump, double jump, shooting, death, enemy hit/death, UI interactions
- **Music System**: Background music with separate audio buses (Music, SFX, UI)
- **Visual Effects**: Blood particle system on death, hit blink on enemies
- **Animations**: Idle, walking, jumping, falling, wall sliding
- **UI Themes**: Consistent styling across menus and HUD

### 💾 Game Management
- **Save System**: Encrypted slot files, create / load / delete from the menu
- **Menu System**: Main menu, load game, pause functionality
- **HUD**: In-game overlay with pause and menu options
- **Game Over**: Death state management with restart options
- **Settings**: Blood effects toggle, volume controls
- **Difficulty**: Easy, Normal, Hard, Very Hard, Impossible (stored per slot)

### ⚙️ Technical Features
- **Global State Management**: Centralized game state through `Env.gd`
- **Storage**: `Storage` autoload for plain JSON and encrypted files
- **Input System**: Configurable controls with keyboard support
- **Scene Management**: Modular room-based scene structure
- **Asset Organization**: Structured folders for sprites, sounds, scripts
- **Collision Layers**: Proper separation between player, threats, and environment (see below)

## Installation & Setup

### Prerequisites
- Godot 4.7 or later
- Basic knowledge of Godot and GDScript

### Quick Start
1. Clone or download this repository
2. Open the project in Godot 4.7+
3. Run the project - it will start with the main menu
4. Play the demo level to test all mechanics

### Project Structure
```
iwbte-godot/
├── Env.gd                 # Global state: settings, slots, difficulty (autoload)
├── Objects/               # Game objects and prefabs
│   ├── Player/            # Player character, blood drop
│   ├── Blocks.tscn        # Platform/block tilemap
│   ├── spikes.tscn        # Spike tilemap
│   ├── Spike.tscn         # Individual spike trap
│   ├── MovingSpike.tscn   # Thrown spike (trigger / direction / enabler)
│   ├── Enemy.tscn         # Enemy with HP and a cherry thrower
│   ├── Cherry.tscn        # Cherry projectile
│   ├── Bullet.res         # Player bullet
│   ├── Save.res           # Save point object
│   └── WallJump.res       # Wall jump area
├── Rooms/                 # Game levels and UI scenes
│   ├── GamePlay/          # Game levels
│   └── Menu/              # Menu screens and HUD
├── Scripts/               # All GDScript files
│   ├── Player.gd          # Main player controller
│   ├── MovingSpike.gd     # Moving spike logic
│   ├── Enemy.gd           # Enemy HP, hit blink, sounds
│   ├── CherryThrower.gd   # Burst cherry throwing with line of sight
│   ├── Save/Storage.gd    # JSON + encrypted file helpers (autoload)
│   ├── Menu/              # Menu system scripts
│   └── [Other mechanics]
├── Sprites/               # All visual assets
├── Sounds/                # Audio files (SFX & Music)
└── Fonts/                 # UI fonts and icons
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
- **Wall Jumping**: Touch a wall jump area to slide down slowly; press jump to jump off it, as many times as you like
- **Save Points**: Shoot save points to create checkpoints
- **Death**: Touching spikes, enemies, cherries or other threats instantly kills the player
- **Respawn**: Players respawn at the last activated save point

## Creating Your Own Levels

### Room Creation
1. Create a new scene inheriting from `Node2D`
2. Add the required components:
   - `PlayerStart.tscn` - Player spawn point
   - `HUD.tscn` - UI overlay
   - Level geometry using `Blocks.tscn`
   - Threats using `spikes.tscn`, `Spike.tscn`, `MovingSpike.tscn`, `Enemy.tscn` or custom threats
   - Save points using `Save.res`

### Collision Layers
Godot shows layers numbered 1-32 in the Inspector; `.tscn` files store them as bit values.

| Inspector layer | Value in `.tscn` | Used for |
|---|---|---|
| 1 | 1 | Blocks/walls, player body, bullets |
| 4 | 8 | Threats: spikes, enemies, cherries and the player's `ThreatController` |
| 5 | 16 | Wall jump areas and the player's `WallJumpController` |

### Adding Threats
- Anything on **layer 4** (value 8) kills the player on contact
- Add it to the "Threats" group to keep things organized
- Spikes are pre-configured but you can create custom threats

### Moving Spikes
Drop `MovingSpike.tscn` into a room. It is built from three parts, all set in the Inspector:

| Part | Properties | What it does |
|---|---|---|
| **Trigger** | `Trigger Offset`, `Trigger Size` (or `Trigger`) | The box the player enters to throw the spike. It is generated in code, relative to the spike. To throw several spikes at once, point their `Trigger` at one shared `Area2D` |
| **Directioner** | `Direction` (Up/Down/Left/Right), `Speed` (700) | Where and how fast the spike flies. The sprite rotates to match, so don't rotate the node yourself |
| **Enabler** | `Enabled On` (difficulty checkboxes) | On unchecked difficulties the spike stays put as a normal spike |

- Triggers never kill: their layer is forced to 0 in code, whatever you set in the editor
- Thrown spikes pass through walls and are freed when they leave the screen
- Turn on **Debug → Visible Collision Shapes** to see the trigger boxes while playing

### Enemies
Drop `Enemy.tscn` into a room.

- **HP**: `Max Hp` (50) and `Damage Per Bullet` (1) in the Inspector, or set `max_hp` from code before adding it. `take_damage(n)` works from anywhere
- **On hit**: bullets disappear, the enemy blinks and plays `BossHit.wav`
- **On death**: it disappears at once and plays `Death.wav`
- **Looking**: it turns to face the player, flipping left/right and tilting towards them
- **Touch**: kills the player (layer 4)

#### Cherry Thrower
Each enemy has a `CherryThrower` child. You can also add the node to a room on its own as a trap, or delete it from an enemy that shouldn't shoot.

| Property | Default | |
|---|---|---|
| `Burst Count` | 3 | Cherries per burst |
| `Burst Rate` | 3.0 | Cherries per second within a burst |
| `Burst Pause` | 1.5 | Seconds between bursts |
| `Cherry Speed` | 600 | |
| `Aim At Player` | on | Otherwise throws towards `Direction` |
| `Require Sight` | on | Only throws when a ray to the player isn't blocked by a wall |
| `Sight Range` | 600 | Max distance at which it sees the player |

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
const GRAVITY = 980.0 * 1.25  # Gravity strength (wall slide uses GRAVITY / 20)
const HSPEED = 140            # Horizontal movement speed
const JUMP_FORCE = 400        # Jump force (floor and wall)
const DJUMP_FORCE = 330       # Double jump force
const BLOOD_AMOUNT = 360      # Blood drops on death
```

Bullet speed is `bullet_force` in `Scripts/Bullet.gd`, in pixels per second (900).

### Game Settings
Modify `Env.gd` for global settings:
- `maxSlots` - number of save slots (3)
- `nameAdjectives` / `nameNouns` - word lists for random slot names
- `difficulty` - difficulty bit flags
- Default settings (volumes, blood, fullscreen) and default slot values

### Visual Customization
- Replace sprites in `Sprites/` folders (the enemy uses `Sprites/Enemy.png`)
- Modify animations in `Objects/Player/Player.tscn`
- Update UI themes in `Rooms/Menu/UI/`

## Audio System

### Sound Effects
- Jump/Double Jump sounds
- Shooting sound
- Death music
- Enemy hit (`BossHit.wav`) and enemy death (`Death.wav`)
- UI interaction sounds

### Music
- Background music system with looping
- Separate audio buses for Music, SFX and UI
- Volume controls in settings

## Save System

### Features
- Up to 3 save slots (`Env.maxSlots`); New Game is disabled when they're full
- Each new slot gets a random funny name like "Soggy Cherry" or "Sneaky Goblin"
- Delete slots from the Load Game screen (with confirmation)
- Automatic position saving
- Room transition persistence

### Files
Stored in the Godot user directory (`user://`):
- `settings.json` - volumes, blood toggle, fullscreen and the list of slot ids (plain JSON)
- `<id>.sav` - one per slot, encrypted with `FileAccess.open_encrypted_with_pass`

> The password lives in `Scripts/Save/Storage.gd`, so the encryption stops casual save editing, not a determined player.

### Save Data Structure
```gdscript
{
  "name": "Soggy Cherry",
  "position": {"x": 176, "y": 352},
  "room": "roomStart",
  "retries": 0,
  "difficulty": 1  # EASY: 1, NORMAL: 2, HARD: 4, VERY_HARD: 8, IMPOSSIBLE: 16
}
```

## Contributing

This engine is designed to be easily extensible. Common additions:
- New trap types
- Power-ups and items
- Boss enemies (movement patterns, attack phases)
- Additional movement mechanics
- Visual effects
- Audio improvements

## Credits

- Original "I Wanna Be The Guy" by [Kayin](https://kayin.itch.io/iwbtg)
- Built with [Godot Engine](https://godotengine.org/)

## License

This project is licensed under the AGPLv3. Please check the LICENSE file for details.

---

**Ready to create your own impossible platformer? Start building with IWBTE for Godot!** 🚀
