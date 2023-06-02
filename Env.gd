extends Node

const fileSettings: String = "user://IWFIO.json"

"""
|--------------------
| Global elements.
|--------------------
|
| Check current slot and the global settings as controls and blood emision.
|
"""
var global: Dictionary = {}
var slot: Dictionary = {}
var nameSlot: String

"""
|--------------------
| In Game Variables
|--------------------
|
| All default in game variables like pause state or check if the player is dead.
|
"""
var paused: bool = false
var dead: bool = false

"""
|--------------------
| Default elements.
|--------------------
|
| Default values for reusing them accross the game.
|
"""
const defaults: Dictionary = {
  "name": null,
  "defeated": {
    "loneliness": false,
    "sadness": false,
    "guiltiness": false,
    "anger": false,
    "negativity": false,
    "oblivion": false,
  },
  "items": [],
  "position": {},
  "retries": 0,
  "difficulty": 0, # 0: easy; 1: normal; 2: hard: 3; Very Hard: 4; Impossible: 5
  "room": "roomStart",
}


func _ready():
  if (!FileAccess.file_exists(fileSettings)):
    global = {
      "blood": true,
      "controls": {
        "jump": "up",
        "left": "left",
        "right": "right",
        "shoot": "z",
      },
      "max_slots": null, # null means no limit.
      "slots": [],
      "volume": {
        "music": 0,
        "sfx": 0,
      },
    }
    save(fileSettings, global)
    return

  readGlobal(fileSettings)


func findSlotOrCreate(date, position):
  if position == null:
    print("No position provided, exiting of method.")
    return

  var fallback = "user://%s.json" % date
  if !FileAccess.open(fallback, FileAccess.READ):
    createSlot(fallback, position, date)
    return

  readSlot(fallback)


func createSlot(filename, position, date):
  # Check if the user has the max slots size activated.
  # In that case we should prevent the creation of a new slot.
  if global.max_slots != null and global.max_slots <= (global.slots.size() + 1):
    return

  slot = defaults.duplicate()
  slot.name = date
  slot.position = position
  save(filename, slot)

  global.slots.push_back(date)
  save(fileSettings, global)

  Env.nameSlot = date


func save(filename, object):
  var handler = FileAccess.open(filename, FileAccess.WRITE_READ)
  handler.store_string(JSON.stringify(object, "  "))
  handler = null


func readGlobal(filename):
  var handler = FileAccess.open(filename, FileAccess.READ)
  global = JSON.parse_string(handler.get_as_text())
  handler = null


func readSlot(filename):
  var handler = FileAccess.open(filename, FileAccess.READ)
  slot = JSON.parse_string(handler.get_as_text())
  Env.nameSlot = slot.name
  handler = null
