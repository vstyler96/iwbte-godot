extends Node

var defaultFileName = "user://IWFIO.json"
var settings: Dictionary
var current_slot: String
@onready var current_settings: Dictionary:
  get:
    return settings.slots[current_slot]
  set(value):
    settings.slots[current_slot] = value
    save()

func _ready():
  settings = read()

func save() -> void:
  var file: FileAccess = FileAccess.open(defaultFileName, FileAccess.WRITE)
  file.store_string(JSON.stringify(Env.settings))
  file = null;

func read() -> Dictionary:
  var fileExists: bool = FileAccess.file_exists(defaultFileName)

  if (!fileExists):
    Env.settings = { "slots": {} }
    save()

  var file: FileAccess = FileAccess.open(defaultFileName, FileAccess.READ)
  var content = JSON.parse_string(file.get_as_text())
  file = null
  return content

func create() -> void:
  Env.current_slot = str(Time.get_unix_time_from_system())
  var defaultName = "Embrace Darkness (%s)"

  Env.settings.slots[Env.current_slot] = {
    "name": defaultName % str(Time.get_date_string_from_unix_time(int(Env.current_slot))),
    "room": "roomStart",
    "position": [192,352],
    "items": [],
    "defeated": {
      "loneliness": false,
      "sadness": false,
      "guiltiness": false,
      "anger": false,
      "negativity": false,
      "oblivion": false,
    },
    "retries": 0,
    "difficulty": "normal",
  }
  Env.save()

func find(timestamp: int) -> void:
  if !Env.settings.slots[timestamp]:
    create()
    return
  Env.current_slot = str(timestamp)
