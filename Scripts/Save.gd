extends Area2D
class_name Save

signal save_game

func _ready():
  pass
  # connect("save_game", Player._on_save_save_game)

func _on_body_entered(body):
  if body is Bullet:
    $Sprite2D.frame = 1
    $Timer.start()
    emit_signal("save_game")

func _on_timer_timeout():
  $Sprite2D.frame = 0
