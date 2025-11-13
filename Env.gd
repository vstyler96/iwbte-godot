extends Node

const difficulty: Dictionary = {
  "EASY": 1,
  "NORMAL": 2,
  "HARD": 4,
  "VERY_HARD": 8,
  "IMPOSSIBLE": 16,
}

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
  return defaultSettings

func readSettings():
  return Storage.read(file)

func setupSettings():
  settings = readSettings() if FileAccess.file_exists(file) else createSettings()

func setupAudio():
  # Set audio volumes
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), settings.music)
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), settings.sfx)
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), settings.ui)


func loadSlot(index: int):
  var slotExists = FileAccess.file_exists("user://%s.sav" % index)
  slot = Storage.readEncrypted("user://%s.sav" % index) if slotExists else defaultSlot.duplicate(true)
  slotIndex = index

func createSlot():
  var index = settings.slots.size() + 1
  slot = defaultSlot.duplicate(true)
  slotIndex = index
  Storage.saveEncrypted("user://%s.sav" % index, slot)

  settings.slots.append(index)
  Storage.save(file, settings)

func updateSlot():
  Storage.saveEncrypted("user://%s.sav" % slotIndex, slot)
