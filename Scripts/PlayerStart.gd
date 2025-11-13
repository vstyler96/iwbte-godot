extends Node2D

@onready var Playable = preload("res://Objects/Player/Player.tscn");

var player: Player;

func _ready():
  Env.dead = false
  Env.paused = false

  player = Playable.instantiate();

  for save in get_tree().get_nodes_in_group("Save"):
    save.connect("save_game", player._on_save_save_game);

  get_parent().add_child.call_deferred(player);

func _process(_delta):
  global_position.x = floor(player.global_position.x / 800) * 800
  global_position.y = floor(player.global_position.y / 608) * 608
