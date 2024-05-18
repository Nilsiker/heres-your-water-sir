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

signal gulped(glass: Glass)
signal choked()
signal recovered

signal monster_roared(intensity: float)

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

var timer: Timer

func _ready():
	timer = get_tree().current_scene.get_node("DrinkTimer")
	timer.timeout.connect(_on_water_timer_timeout)

func _process(delta):
	upset_amount = max(0, upset_amount - calming_factor * delta)
	
func _on_water_timer_timeout():
	glass_spawned.emit()
	glass_count += 1
	
func hold_glass(glass: Glass):
	if not glass_count: return
	glass_held.emit(glass)

func drop_glass(glass: Glass):
	glass_dropped.emit(glass)
	
func gulp(glass: Glass):
	gulped.emit(glass)

func choke(glass: Glass):
	choked.emit()

func shatter_glass(glass: Glass):
	glass_count -= 1
	glass_shattered.emit(glass)

func monster_roar():
	if upset_amount > 1:
		_game_over()

	upset_amount += 0.15
	monster_roared.emit(upset_amount)
			
func start_sequence():
	start_sequence_started.emit()

func start():
	timer.start()
	state = State.Chained
	game_started.emit()
	
func recover():
	recovered.emit()

func increment_score():
	glass_drunk += 1
	timer.wait_time -= .3


func _game_over():
	game_over.emit()
	GameState.state = State.GameOver


func _input(_event):
	if Input.is_key_pressed(KEY_G):
		_game_over()