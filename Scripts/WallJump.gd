extends Area2D
class_name WallJump

@export var direction = false

# Called when the node enters the scene tree for the first time.
func _ready():
  $Sprite2D.flip_h = direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass
