extends Node

signal spawned(glass:Glass)
signal held(glass:Glass)
signal gulped(glass:Glass)
signal choked
signal dropped
signal shattered

func _ready():
	%DrinkTimer.timeout.connect(spawn)

func gulp():
	gulped.emit()

func spawn():
	GameState.glass_count += 1
	spawned.emit()

func drop():
	dropped.emit()

func shatter():
	shattered.emit()
	
func hold_glass(glass: Glass):
	if not GameState.glass_count: return
	held.emit(glass)

func drop_glass(glass: Glass):
	dropped.emit(glass)

func choke():
	choked.emit()

func shatter_glass(glass: Glass):
	GameState.glass_count -= 1
	shattered.emit(glass)