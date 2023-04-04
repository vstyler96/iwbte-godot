extends Node

@onready var Env = $"/root/Env";
@onready var Buttons = $Buttons
@onready var hoverSound = preload("res://Sounds/SFX/DJump.wav")

func _on_new_game_pressed():
  Env.create();
  get_tree().change_scene_to_file("res://Rooms/GamePlay/roomStart.tscn")

func _on_load_game_pressed():
  get_tree().change_scene_to_file("res://Rooms/Menu/LoadSavedGame.tscn")

func _on_settings_pressed():
  print("Move to settings View.")

func _on_button_mouse_entered():
  var audio = AudioStreamPlayer2D.new()
  audio.stream = hoverSound;
  audio.bus = "SFX"
  add_child(audio)
  audio.play()
