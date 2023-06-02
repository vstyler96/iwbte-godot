extends CharacterBody2D
class_name Player

@onready var jumpSound = preload("res://Sounds/SFX/Jump.wav")
@onready var dJumpSound = preload("res://Sounds/SFX/DJump.wav")
@onready var shootSound = preload("res://Sounds/SFX/Shoot.wav")

@onready var Death = $OnDeath
@onready var Bullet = preload("res://Objects/Bullet.res")
@onready var Blood = preload("res://Objects/Player/Blood.tscn")
@onready var MainCollider = $CollisionShape2D

signal position_changed

const GRAVITY = 980
const VSPEED = 400
const HSPEED = 140

const JUMP_FORCE = 400
const DJUMP_FORCE = 330
var d_jump: bool = true
var on_water: bool = false
var walls: int = 0

func _ready():
  randomize()

  global_position.x = Env.slot.position.x
  global_position.y = Env.slot.position.y

func _input(event):
  handle_restart(event)

func _physics_process(delta):
  if Env.paused || Env.dead: return

  if !is_on_floor():
    if walls > 0 and velocity.y > 0:
      velocity.y += GRAVITY * (delta / 5)
      velocity.y = min(velocity.y, GRAVITY)
    else:
      velocity.y += GRAVITY * delta
      velocity.y = min(velocity.y, GRAVITY)

  velocity.x = move_toward(velocity.x, 0, HSPEED)

  handle_player_movement(delta)
  handle_shooting()
  handle_animations()
  move_and_slide()


func handle_restart(event):
  if event.is_action_pressed("kill_player"):
    kill_player()
    return

  if event.is_action_pressed("ui_restart"):
    Env.dead = false
    get_tree().reload_current_scene()


func handle_player_movement(delta):
  handle_jump()
  handle_movement()

func handle_jump():
  if walls > 0 and !is_on_floor() and !is_on_wall() and Input.is_action_pressed("move_jump"):
    emit_signal("position_changed", global_position)
    velocity.y = -DJUMP_FORCE
    $JumpFX.stream = dJumpSound
    $JumpFX.play()


  if Input.is_action_just_pressed("move_jump"):
    emit_signal("position_changed", global_position)

    if is_on_floor():
      d_jump = true
      velocity.y = -JUMP_FORCE
      $JumpFX.stream = jumpSound
      $JumpFX.play()
      return

    if d_jump:
      velocity.y = -DJUMP_FORCE
      d_jump = false
      $JumpFX.stream = dJumpSound
      $JumpFX.play()

func handle_movement():
  var direction = int(Input.get_axis("move_left", "move_right"))
  match direction:
      -1, 1:
        emit_signal("position_changed", global_position)
        velocity.x = direction * HSPEED
        $Sprite.flip_h = direction < 0;
      0:
        velocity.x = move_toward(velocity.x, 0, HSPEED)

"""
----------------------------
| Multiple handlers
----------------------------
| Here we will handle all of the animations.
|
"""
func handle_animations():
  if Env.paused: return

  if !is_on_floor():
    if velocity.y > 0:
      if walls > 0:
        $Sprite.play("Sliding")
        return
      $Sprite.play("Fall")
      return
    $Sprite.play("Jump")
    return

  if velocity.x == 0:
    $Sprite.play("Idle")
    return

  $Sprite.play("Walk")


func handle_shooting():
  if Input.is_action_just_pressed("player_shoot") and walls <= 0 and !Env.dead:
    var bullet = Bullet.instantiate()
    var direction = -1 if $Sprite.flip_h else 1;
    get_parent().add_child(bullet)
    bullet.rotation *= direction
    bullet.bullet_force *= direction
    bullet.global_position = Vector2(
      global_position.x + (10 * direction),
      global_position.y + 2
    )
    $BulletFX.stream = shootSound
    $BulletFX.play()


"""
----------------------------
| Kill Player
----------------------------
| Here we handle the kill_player settings and execution
|
"""

func kill_player():
  visible = false

  $CollisionShape2D.queue_free()
  $ThreatController.queue_free()

  if Env.global.blood:
    emit_blood()

  MainCollider
  Death.play()
  Env.dead = true

func emit_blood():
  for i in 36:
    var blood = Blood.instantiate()
    blood.global_position = global_position
    get_parent().add_child(blood)
    blood.linear_velocity = Vector2.from_angle(i * 60) * 1200

"""
----------------------------
| Signals callbacks
----------------------------
| Here we handle the signals callbacks
|
"""

func _on_threat_controller_area_or_body_entered(_area):
  kill_player()

func _on_save_save_game():
  if !Env.dead || Env.paused:
    Env.slot.room = get_tree().current_scene.name

    Env.slot.position.x = global_position.x
    Env.slot.position.y = global_position.y

    Env.save("user://%s.json" % Env.nameSlot, Env.slot)


func _on_wall_jump_controller_area_entered(area):
  walls += 1

func _on_wall_jump_controller_area_exited(area):
  walls -= 1

func handle_camera_movement():
  pass
