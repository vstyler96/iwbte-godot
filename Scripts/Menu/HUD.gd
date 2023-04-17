extends Control

@onready var hoverSound = preload("res://Sounds/SFX/DJump.wav")
@onready var PauseButton = $HBoxContainer/Button
# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  $GameOver.visible = Env.dead

func _on_button_mouse_entered():
  var audio = AudioStreamPlayer2D.new()
  audio.stream = hoverSound;
  audio.bus = "SFX"
  add_child(audio)
  audio.play()

func _on_button_pressed():
  Env.paused = !Env.paused
  PauseButton.text = "Resume" if Env.paused else "Pause"
  PauseButton.icon = preload("res://Fonts/icons/pause-circle.svg") if Env.paused else preload("res://Fonts/icons/play-circle.svg")
