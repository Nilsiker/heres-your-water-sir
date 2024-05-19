extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.start_sequence_started.connect(_on_start_sequence_started)
	GameState.free_player_sequence_started.connect(_on_free_player_sequence_started)
	GameState.game_finished_sequence_started.connect(_on_game_finished_sequence_started)
	GameState.player_freed.connect(_on_player_freed)
	GameState.game_over.connect(_on_game_over)

func _on_start_sequence_started():
	$AnimationPlayer.play("game_started")

func finish_start_sequence():
	GameState.start()

func _on_free_player_sequence_started():
	$AnimationPlayer.play("free_player")

func finish_free_player_sequence():
	GameState.free_player()

func _on_game_over():
	$AnimationPlayer.play("game_over")


func _on_game_finished_sequence_started():
	$FinishScreen.visible = true
	$FinishScreen._on_visible()
	$FinishAudio.play()


func _input(event):
	if $FinishScreen.visible and event.is_action_pressed("continue"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	if $GameOver.visible and event.is_action_pressed("continue"):
		$GameOver.visible = false
		$AnimationPlayer.play("game_started")

func _on_player_freed():
	get_tree().current_scene.get_node("Flashlight").on()

func shatter_all():
	GameState.all_shattered.emit()