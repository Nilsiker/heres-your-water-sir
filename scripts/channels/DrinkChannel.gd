extends Node

signal spawned(glass: Glass)
signal held(glass: Glass)
signal gulped(glass: Glass)
signal choked
signal dropped(glass: Glass)
signal shattered(glass: Glass)

var GLASS_AMOUNT = 3

func _ready():
	GameState.game_started.connect(_on_game_started)
	GameState.water_drunk_updated.connect(_on_water_drunk_updated)

func _on_game_started():
	GLASS_AMOUNT = 3
	timer().timeout.connect(spawn)
	timer().start()

func gulp(glass: Glass):
	gulped.emit(glass)

func spawn():
	GameState.glass_count += 1
	spawned.emit()

func drop(glass: Glass):
	dropped.emit(glass)

func shatter(glass: Glass):
	GameState.glass_count -= 1
	timer().wait_time =  max(0.5, timer().wait_time - 0.2)
	shattered.emit(glass)
	
func hold(glass: Glass):
	if not GameState.glass_count: return
	held.emit(glass)

func choke():
	choked.emit()

func timer() -> Timer:
	return get_tree().current_scene.get_node("DrinkTimer")

func _on_water_drunk_updated(count: int):
	match count:
		5: GLASS_AMOUNT = 4
		10: GLASS_AMOUNT = 5
		15: GLASS_AMOUNT = 6
		20: GLASS_AMOUNT = 7