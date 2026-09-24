extends Area2D
class_name MovingSpike

const DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

## Trigger: area the player touches to throw the spike. Leave empty to build one
## from trigger_offset/trigger_size; or point several spikes at one shared Area2D
## (collision layer 0, mask 8) to throw them together.
@export var trigger: Area2D
## Center of the built trigger, relative to the spike.
@export var trigger_offset: Vector2 = Vector2(0, -64)
@export var trigger_size: Vector2 = Vector2(32, 32)
## Directioner: where the spike is thrown.
@export_enum("Up", "Down", "Left", "Right") var direction: int = 0
@export var speed: float = 700.0
## Enabler: difficulties this spike is thrown on. Otherwise it stays as a static spike.
@export_flags("Easy", "Normal", "Hard", "Very Hard", "Impossible") var enabled_on: int = 31

var velocity: Vector2 = Vector2.ZERO

func _ready():
  # Rotate only the visuals/hitbox so the trigger offset isn't rotated with them.
  var angle = DIRECTIONS[direction].angle() + PI / 2
  $Sprite2D.rotation = angle
  $CollisionPolygon2D.rotation = angle

  if trigger == null:
    trigger = build_trigger()
  # Layer 0 so a trigger never counts as a threat (only the spike kills);
  # mask 8 (layer 4) so it sees the player's ThreatController.
  trigger.collision_layer = 0
  trigger.collision_mask = 8
  trigger.area_entered.connect(_on_trigger_area_entered)

func build_trigger() -> Area2D:
  var area = Area2D.new()
  var shape = CollisionShape2D.new()
  shape.shape = RectangleShape2D.new()
  shape.shape.size = trigger_size
  shape.position = trigger_offset
  area.add_child(shape)
  add_child(area)
  return area

func _physics_process(delta):
  position += velocity * delta

func _on_trigger_area_entered(area: Area2D):
  if !area.is_in_group("Player"):
    return
  trigger.area_entered.disconnect(_on_trigger_area_entered)

  if (Env.slot.get("difficulty", Env.difficulty.EASY) & enabled_on) == 0:
    return
  velocity = DIRECTIONS[direction] * speed
