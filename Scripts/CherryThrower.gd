extends Node2D
class_name CherryThrower

## Throws bursts of cherries: burst_count at burst_rate per second, then waits burst_pause.
@export var burst_count: int = 3
@export var burst_rate: float = 3.0
@export var burst_pause: float = 1.5
@export var cherry_speed: float = 600.0
## Aim at the player; otherwise (or with no player around) throw towards `direction`.
@export var aim_at_player: bool = true
@export var direction: Vector2 = Vector2.LEFT
## Only throw while the player is in sight: within sight_range and no wall (layer 1) in between.
@export var require_sight: bool = true
@export var sight_range: float = 600.0

var cherryScene = preload("res://Objects/Cherry.tscn")
var timer = Timer.new()
var thrown: int = 0
var ray = RayCast2D.new()

func _ready():
  # A Timer child (not awaits) so everything stops cleanly when the owner is freed.
  timer.one_shot = true
  timer.timeout.connect(_on_timer_timeout)
  add_child(timer)
  timer.start(burst_pause)

  # Walls only: cherries and the player's areas must not block the line of sight.
  ray.collision_mask = 1
  ray.collide_with_areas = false
  ray.enabled = false # only cast on demand in can_see_player()
  add_child(ray)

func _on_timer_timeout():
  throw()
  thrown += 1
  if thrown >= burst_count:
    thrown = 0
    timer.start(burst_pause)
  else:
    timer.start(1.0 / burst_rate)

func throw():
  # Hidden means the owner is dead (Enemy.die hides it while its hit sound plays).
  if !is_visible_in_tree():
    return
  if require_sight and !can_see_player():
    return
  var cherry = cherryScene.instantiate()
  cherry.global_position = global_position
  cherry.velocity = aim() * cherry_speed
  # Into the room, not under us, so cherries don't follow a moving enemy or vanish with it.
  var room = get_tree().current_scene if get_tree().current_scene else get_tree().root
  room.add_child(cherry)

func can_see_player() -> bool:
  var player = get_tree().get_first_node_in_group("Player")
  if player == null or Env.dead:
    return false
  var to_player = player.global_position - global_position
  if to_player.length() > sight_range:
    return false
  ray.target_position = to_player
  ray.force_raycast_update()
  # The player's own body is on layer 1 too, so reaching it counts as seeing it.
  return !ray.is_colliding() or ray.get_collider() is Player

func aim() -> Vector2:
  # The player's ThreatController is the node in the "Player" group.
  var player = get_tree().get_first_node_in_group("Player")
  if aim_at_player and player and !Env.dead:
    return global_position.direction_to(player.global_position)
  return direction.normalized()
