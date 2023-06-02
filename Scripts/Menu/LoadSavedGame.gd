extends Control

@onready var hoverSound = preload("res://Sounds/SFX/DJump.wav")

func _ready():
  if Env.global.slots.size() > 0:
    $Menu.visible = true

    for key in Env.global.slots:
      var button = Button.new()
      button.theme = preload("res://Rooms/Menu/UI/UI.tres")
      button.text = "Slot (%s)" % key
      button.pressed.connect(self.loadSavedGame.bind(key))
      button.mouse_entered.connect(self._on_button_mouse_entered);
      $Menu/VBoxContainer.add_child(button);
  else:
    $EmptyState.visible = true


func loadSavedGame(key: String):
  Env.readSlot("user://%s.json" % key)

  var scene = "res://Rooms/GamePlay/%s.tscn"
  var room = Env.slot.room
  get_tree().change_scene_to_file(scene % room)


func _on_button_pressed():
  get_tree().change_scene_to_file("res://Rooms/Menu/Menu.tscn")

func _on_button_mouse_entered():
  var audio = AudioStreamPlayer2D.new()
  audio.stream = hoverSound;
  audio.bus = "SFX"
  add_child(audio)
  audio.play()
