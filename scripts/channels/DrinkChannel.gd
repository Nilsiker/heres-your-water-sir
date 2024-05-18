extends Node

signal spawned(glass: Glass)
signal held(glass: Glass)
signal gulped(glass: Glass)
signal choked
signal dropped(glass: Glass)
signal shattered(glass: Glass)

func _ready():
	GameState.game_started.connect(_on_game_started)

func _on_game_started():
	timer().timeout.connect(spawn)
	timer().start()

func gulp(glass: Glass):
	gulped.emit(glass)

func spawn():
	print("DrinkChannel spawn")
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