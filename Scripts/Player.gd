extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var secondJump: bool = false
var jumpAnimationLoops: int = 0

func _ready():
  randomize()
  global_position = Vector2(
    Env.current_settings.position[0],
    Env.current_settings.position[1]
  )

func _process(_delta):
  if $Sprite.animation_looped and jumpAnimationLoops > 0:
    jumpAnimationLoops -= 1

func _physics_process(delta):
  var jump = Input.is_action_just_pressed("move_jump");

  if not is_on_floor():
    if jumpAnimationLoops > 0:
      $Sprite.animation = "Jump"
    else:
      $Sprite.animation = "Fall"

    velocity.y += gravity * delta

    if secondJump and jump:
      jumpAnimationLoops = 25
      secondJump = false
      velocity.y = JUMP_VELOCITY * 3/4

  if jump and is_on_floor():
    jumpAnimationLoops = 25
    secondJump = true
    velocity.y = JUMP_VELOCITY

  var direction = Input.get_axis("move_left", "move_right")
  if direction:
    $Sprite.flip_h = true if direction < 0 else false
    if is_on_floor():
      $Sprite.animation = "Walk"
    velocity.x = direction * SPEED
  else:
    if is_on_floor():
      $Sprite.animation = "Idle"
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()

func killPlayer():
  startBlood()
  $Audio.stream = preload("res://Sounds/OnDeath.mp3")
  $Audio.play()
  visible = false;

func startBlood():
  var sprite = Sprite2D.new()
  var collision = CollisionShape2D.new()
  var rect2D = RectangleShape2D.new()

  sprite.texture = preload("res://Sprites/Player/Addons/blood.png")
  sprite.hframes = 3;
  sprite.frame = randi_range(0, 2)
  rect2D.size = Vector2(2, 2)
  collision.shape = rect2D

  var radians = 3.1416 / 180

  for i in 359:
    var rigid = RigidBody2D.new()
    rigid.add_child(sprite)
    rigid.add_child(collision)
    get_parent().add_child(rigid)
    rigid.global_position = global_position
    print(Vector2.from_angle(i * radians) * 500)
    rigid.apply_central_impulse(Vector2.from_angle(i * radians) * 500)
