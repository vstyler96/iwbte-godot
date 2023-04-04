extends Node2D

const SPEED = 20

func process(event):
  if Input.is_action_pressed("ui_left"):
    $RigidBody2D.apply_force(Vector2.LEFT * SPEED, Vector2.LEFT)
    return

  if Input.is_action_pressed("ui_right"):
    $RigidBody2D.apply_force(Vector2.RIGHT * SPEED, Vector2.RIGHT)
    return

