extends Area2D
class_name Cherry

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
  position += velocity * delta
