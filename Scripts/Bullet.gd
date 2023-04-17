extends AnimatableBody2D

@export var bullet_force: Vector2 = Vector2(15, 0)

func _process(delta):
  if move_and_collide(bullet_force):
    queue_free()
