extends CharacterBody2D

# signal on_death()

@onready var Death = $OnDeath
@onready var Bullet = preload("res://Objects/Bullet.res")
@onready var BulletSound = $SoundFX
@onready var Blood = preload("res://Objects/Player/Blood.tscn")
@onready var MainCollider = $CollisionShape2D
@onready var ThreatCollider = $ThreatController/CollisionShape2D

const GRAVITY = 980 # ProjectSettings.get_setting("physics/2d/default_gravity")
const VSPEED = 400
const HSPEED = 140

const JUMP_FORCE = 400
const DJUMP_FORCE = 330
var d_jump: bool = true
var on_water: bool = false

func _ready():
  randomize()
  global_position = Vector2(
    Env.current_settings.position[0],
    Env.current_settings.position[1]
  )

func _process(delta):
  if Input.is_action_just_pressed("ui_restart"):
    Env.dead = false
    get_tree().reload_current_scene()
    _toggle_colliders(true)

func _physics_process(delta):
  if Env.dead || Env.paused: return
  var jump = Input.is_action_pressed("move_jump");
  if !is_on_floor():
    velocity.y += GRAVITY * delta
    velocity.y = min(VSPEED, velocity.y)

  var direction = int(Input.get_axis("move_left", "move_right"))
  match direction:
      -1, 1:
        velocity.x = direction * HSPEED
        $Sprite.flip_h = direction < 0;
      0:
        velocity.x = move_toward(velocity.x, 0, HSPEED)

  handle_animations()
  handle_jump()
  handle_shooting()
  move_and_slide()

"""
----------------------------
| Multiple handlers
----------------------------
| Here we will handle all of the animations.
|
"""
func handle_animations():
  if !is_on_floor():
    if velocity.y > 0:
      $Sprite.play("Fall")
      return
    $Sprite.play("Jump")
    return

  if velocity.x == 0:
    $Sprite.play("Idle")
    return

  $Sprite.play("Walk")

func handle_jump():
  d_jump = true

  if Input.is_action_just_pressed("move_jump"):
    if is_on_floor():
      velocity.y = -JUMP_FORCE

    if d_jump || on_water:
      velocity.y = -DJUMP_FORCE
      d_jump = false

func handle_shooting():
  if Input.is_action_just_pressed("player_shoot") && visible:
    var bullet = Bullet.instantiate()
    var direction = -1 if $Sprite.flip_h else 1;
    get_parent().add_child(bullet)
    bullet.rotation *= direction
    bullet.global_position = Vector2(
      global_position.x + (10 * direction),
      global_position.y + 2
    )
    bullet.bullet_force *= direction
    BulletSound.play()


"""
----------------------------
| Kill Player
----------------------------
| Here we handle the kill_player settings and execution
|
"""

func kill_player():
  _toggle_colliders(false)
  emit_blood()
  MainCollider
  Death.play()
  visible = false
  Env.dead = true

func emit_blood():
  for i in 36:
    var blood = Blood.instantiate()
    blood.global_position = global_position
    get_parent().add_child(blood)
    blood.linear_velocity = Vector2.from_angle(i * 10) * 1200

func _toggle_colliders(enable):
  ThreatCollider.disabled = enable
  MainCollider.disabled = enable

"""
----------------------------
| Signals callbacks
----------------------------
| Here we handle the signals callbacks
|
"""

func _on_threat_controller_area_or_body_entered(area):
  kill_player()
