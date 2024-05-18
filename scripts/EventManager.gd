extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.start_sequence_started.connect(_on_start_sequence_started)
	GameState.game_over.connect(_on_game_over)

func _on_start_sequence_started():
	$AnimationPlayer.play("game_started")

func finish_start_sequence():
	GameState.start()

func _on_game_over():
	$AnimationPlayer.play("game_over")


func _input(event):
	if $GameOver.visible and event is InputEventKey:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
