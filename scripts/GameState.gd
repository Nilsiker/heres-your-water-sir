extends Node

signal game_started
signal game_over
signal player_freed
signal game_finished

signal start_sequence_started
signal free_player_sequence_started
signal game_finished_sequence_started

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
	InSequence,
	Free,
	GameOver,
	Finished
}

var state = State.Menu

var allow_non_waters = false
var allow_lamp_flickering = false
var allow_sloppy_monster = false
var allow_lowercase = false

var combination: String
var glass_count: int = 0
var waters_drunk: int = 0
var upset_amount = 0
var calming_factor = 0.01

var WATERS_DRUNK_TO_WIN:
	get: return 25
			
func start_sequence():
	GameState.state = State.InSequence
	start_sequence_started.emit()

func start_free_player_sequence():
	GameState.state = State.InSequence
	free_player_sequence_started.emit()

func start_finish_game_sequence():
	GameState.state = GameState.State.InSequence
	game_finished_sequence_started.emit()


func start():
	upset_amount = 0
	waters_drunk = 0
	water_drunk_updated.emit(waters_drunk)

	state = State.Chained
	game_started.emit()
	print("Game started")
	
func recover():
	recovered.emit()

func increment_score():
	waters_drunk += 1
	if not allow_non_waters and waters_drunk == 5:
		allow_non_waters = true
	if not allow_lowercase and waters_drunk == 10:
		allow_lowercase = true
	if not allow_sloppy_monster and waters_drunk == 15:
		allow_sloppy_monster = true
	if not allow_lamp_flickering and waters_drunk == 20:
		allow_lamp_flickering = true

	water_drunk_updated.emit(waters_drunk)
	if waters_drunk >= WATERS_DRUNK_TO_WIN:
		start_free_player_sequence()

func upset(added_upset):
	upset_amount += added_upset
	if upset_amount > 2 and state == State.Chained:
		_game_over()

func _game_over():
	game_over.emit()
	GameState.state = State.GameOver

func _input(_event):
	if Input.is_key_pressed(KEY_G):
		_game_over()
	if Input.is_key_pressed(KEY_F):
		start_free_player_sequence()

func free_player():
	player_freed.emit()
	state = State.Free
