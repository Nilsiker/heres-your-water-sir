
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(finish)

func finish(body):
	if body is Player: GameState.start_finish_game_sequence()