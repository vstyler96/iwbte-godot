extends Control

@onready var hoverSound = preload("res://Sounds/SFX/DJump.wav")

func _ready():
  if Env.settings.slots.size() > 0:
    $Menu.visible = true

    for index in Env.settings.slots.size():
      var button = Button.new()
      button.theme = preload("res://Rooms/Menu/UI/UI.tres")
      button.text = "Slot (%s)" % index
      button.pressed.connect(self.loadSlot.bind(index))
      button.mouse_entered.connect(self._on_button_mouse_entered)
      $Menu/VBoxContainer.add_child(button)
  else:
    $EmptyState.visible = true

func loadSlot(index: int):
  Env.loadSlot(index)
  get_tree().change_scene_to_file("res://Rooms/GamePlay/%s.tscn" % Env.slot.room)

func _on_button_pressed():
  get_tree().change_scene_to_file("res://Rooms/Menu/Menu.tscn")

func _on_button_mouse_entered():
  var audio = AudioStreamPlayer2D.new()
  audio.stream = hoverSound;
  audio.bus = "SFX"
  add_child(audio)
  audio.play()
