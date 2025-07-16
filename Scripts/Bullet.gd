extends AnimatableBody2D
class_name Bullet

@export var bullet_force: Vector2 = Vector2(15, 0)

func _process(_delta):
  if move_and_collide(bullet_force):
    queue_free()
