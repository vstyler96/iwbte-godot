extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var secondJump: bool = false
var jumpAnimationLoops: int = 0

func _process(_delta):
  if $Sprite.animation_looped and jumpAnimationLoops > 0:
    jumpAnimationLoops -= 1

func _physics_process(delta):
  var jump = Input.is_action_just_pressed("ui_accept");

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

  # Handle Jump.
  if jump and is_on_floor():
    jumpAnimationLoops = 25
    secondJump = true
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var direction = Input.get_axis("ui_left", "ui_right")
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
