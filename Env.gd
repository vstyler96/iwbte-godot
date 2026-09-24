extends Node

const difficulty: Dictionary = {
  "EASY": 1,
  "NORMAL": 2,
  "HARD": 4,
  "VERY_HARD": 8,
  "IMPOSSIBLE": 16,
}

const maxSlots: int = 3
const file: String = "user://settings.json"
const defaultSettings: Dictionary = {
  "music": -20,
  "sfx": -20,
  "ui": -20,
  "blood": true,
  "fullscreen": false,
  "slots": [],
}
const defaultSlot: Dictionary = {
  "position": {
    "x": 176,
    "y": 352,
  },
  "room": "roomStart",
  "retries": 0,
  "difficulty": difficulty.EASY,
}
const nameAdjectives: Array[String] = [
  "Soggy", "Brave", "Sneaky", "Wobbly", "Grumpy", "Crispy", "Sleepy", "Spicy",
  "Clumsy", "Fluffy", "Cursed", "Sweaty", "Tiny", "Angry", "Confused",
]
const nameNouns: Array[String] = [
  "Cherry", "Spike", "Kid", "Apple", "Pickle", "Noodle", "Potato", "Goblin",
  "Waffle", "Banana", "Nugget", "Toaster", "Llama", "Muffin", "Oblivion",
]

var settings: Dictionary
var slot: Dictionary
var slotIndex: int = 0
var dead: bool = false
var paused: bool = false

func _ready():
  setupSettings()
  setupAudio()

func createSettings():
  Storage.save(file, defaultSettings)
  return defaultSettings.duplicate(true)

func readSettings():
  return Storage.read(file)

func setupSettings():
  settings = readSettings() if FileAccess.file_exists(file) else createSettings()
  # JSON loads numbers as floats; keep slot ids as ints so has()/erase() match.
  settings.slots = settings.get("slots", []).map(func(i): return int(i))

func setupAudio():
  # Set audio volumes
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), settings.music)
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), settings.sfx)
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), settings.ui)


func loadSlot(index: int):
  var slotExists = FileAccess.file_exists("user://%s.sav" % index)
  slot = Storage.readEncrypted("user://%s.sav" % index) if slotExists else {}
  if slot.is_empty():
    slot = defaultSlot.duplicate(true)
  # JSON loads numbers as floats; difficulty is used as bit flags, so keep it an int.
  slot.difficulty = int(slot.get("difficulty", difficulty.EASY))
  slotIndex = index

func createSlot() -> bool:
  if settings.slots.size() >= maxSlots:
    return false

  var index = 1
  while settings.slots.has(index):
    index += 1
  slot = defaultSlot.duplicate(true)
  slot.name = "%s %s" % [nameAdjectives.pick_random(), nameNouns.pick_random()]
  slotIndex = index
  Storage.saveEncrypted("user://%s.sav" % index, slot)

  settings.slots.append(index)
  Storage.save(file, settings)
  return true

func deleteSlot(index: int):
  DirAccess.remove_absolute("user://%s.sav" % index)
  settings.slots.erase(index)
  Storage.save(file, settings)

func updateSlot():
  Storage.saveEncrypted("user://%s.sav" % slotIndex, slot)
