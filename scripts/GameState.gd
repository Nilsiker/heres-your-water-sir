extends Node

signal game_started
signal game_over
signal player_freed
signal game_finished

signal start_sequence_started

signal glass_spawned
signal glass_held(glass: Glass)
signal glass_dropped(glass: Glass)
signal glass_shattered(glass: Glass)

signal water_drunk_updated(count: int)

signal gulped(glass: Glass)
signal choked()
signal recovered

enum State {
	Menu,
	Chained,
	Free,
	GameOver
}

var state = State.Menu

var combination: String
var glass_count: int = 0
var glass_drunk: int = 0
var upset_amount = 0
var calming_factor = 0.01
			
func start_sequence():
	start_sequence_started.emit()

func start():
	upset_amount = 0
	glass_drunk = 0
	water_drunk_updated.emit(glass_drunk)

	state = State.Chained
	game_started.emit()
	print("Game started")
	
func recover():
	recovered.emit()

func increment_score():
	glass_drunk += 1
	water_drunk_updated.emit(glass_drunk)

func upset(added_upset):
	upset_amount += added_upset
	if upset_amount > 2:
		_game_over()

func _game_over():
	game_over.emit()
	GameState.state = State.GameOver

func _input(_event):
	if Input.is_key_pressed(KEY_G):
		_game_over()