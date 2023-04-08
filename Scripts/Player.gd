extends CharacterBody2D

@export var SPEED: float = 250
@export var GRAVITY = 1000
@export var JUMP: float = 20

@onready var Env = $"/root/Env"

var jumpAnimation: int = false
var jumpsAllowed: int = 0;

func _ready():
  pass
  # var settings = Env.current_settings.position
  # self.global_position = Vector2(settings[0], settings[1])

func _process(delta):
  if not is_on_floor():
    velocity.y += GRAVITY * delta

func _physics_process(delta):
  var left = Input.is_action_pressed("move_left")
  var right = Input.is_action_pressed("move_right")
  var jump = Input.is_action_just_pressed("move_jump")

  move_and_slide()

  if $Sprite.animation_looped:
    jumpAnimation -= 1

  if jumpsAllowed > 0 && jump:
    jumpsAllowed -= 1
    jumpAnimation = 10
    apply_jump(delta)

  if left || right:
    if is_on_floor():
      $Sprite.animation = "Walk"
    $Sprite.flip_h = left
    move(delta, left, right)

  if !left && !right:
    velocity.x = 0

    if is_on_floor():
      jumpsAllowed = 2
      $Sprite.animation = "Idle"
    else:
      $Sprite.animation = "Jump"
      if jumpAnimation < 1:
        $Sprite.animation = "Fall"

func move(delta, left, right):
  var direction = int(right) - int(left)
  velocity.x += direction * SPEED * delta

func apply_jump(delta):
  velocity.y = -JUMP * GRAVITY * delta
