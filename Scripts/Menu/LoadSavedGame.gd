extends Node2D

@onready var Env = $"/root/Env"
@onready var hoverSound = preload("res://Sounds/SFX/DJump.wav")

func _ready():
  for key  in Env.settings.slots:
    var button = Button.new()
    var slot = Env.settings.slots[key]
    button.theme = preload("res://Rooms/Menu/UI/UI.tres")
    button.text = "Slot: " + slot.name
    button.pressed.connect(self.loadSavedGame.bind(key))
    button.mouse_entered.connect(self._on_button_mouse_entered);
    $CanvasLayer/CenterMenu/VBoxContainer.add_child(button);

func loadSavedGame(key: String):
  Env.current_slot = key;
  var scene = "res://Rooms/GamePlay/%s.tscn"
  var room = Env.settings.slots[key].room
  get_tree().change_scene_to_file(scene % room)


func _on_button_pressed():
  get_tree().change_scene_to_file("res://Rooms/Menu/Menu.tscn")

func _on_button_mouse_entered():
  var audio = AudioStreamPlayer2D.new()
  audio.stream = hoverSound;
  audio.bus = "SFX"
  add_child(audio)
  audio.play()
