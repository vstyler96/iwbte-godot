extends AnimatableBody2D
class_name Bullet

## Pixels per second (sign flipped by the player when shooting left).
@export var bullet_force: Vector2 = Vector2(900, 0)

# Physics ticks, not frames: same speed at any FPS, and every step is checked
# against areas (enemies, saves) so a bullet can't skip past them on high refresh rates.
func _physics_process(delta):
  if move_and_collide(bullet_force * delta):
    queue_free()
