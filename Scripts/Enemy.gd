extends Area2D
class_name Enemy

## Can be changed per instance in the Inspector, or from code before adding it to the tree.
@export var max_hp: int = 50
@export var damage_per_bullet: int = 1

var hp: int
var blink: Tween

func _ready():
  hp = max_hp
  body_entered.connect(_on_body_entered)

func _physics_process(_delta):
  look_at_player()

func look_at_player():
  # The player's ThreatController is the node in the "Player" group.
  var player = get_tree().get_first_node_in_group("Player")
  if player == null:
    return
  # The sprite faces left: flip it when the player is to the right, then tilt
  # the face towards the player (flipping first keeps it from going upside down).
  var to_player = player.global_position - global_position
  var facing_right = to_player.x > 0
  $Sprite2D.flip_h = facing_right
  $Sprite2D.rotation = to_player.angle() if facing_right else (-to_player).angle()

func _on_body_entered(body):
  # Layer 4 (threat) makes the player die on touch; mask 1 is only here to see bullets.
  if body is Bullet:
    body.queue_free()
    take_damage(damage_per_bullet)

func take_damage(amount: int):
  if hp <= 0:
    return
  hp -= amount
  if hp <= 0:
    die()
    return
  $HitFX.play()
  flash()

func flash():
  if blink:
    blink.kill()
  $Sprite2D.modulate.a = 1.0
  blink = create_tween().set_loops(3)
  blink.tween_property($Sprite2D, "modulate:a", 0.2, 0.04)
  blink.tween_property($Sprite2D, "modulate:a", 1.0, 0.04)

func die():
  # Stop being a threat right away, but let the death sound finish before freeing.
  hide()
  $CollisionShape2D.set_deferred("disabled", true)
  $DeathFX.play()
  await $DeathFX.finished
  queue_free()
