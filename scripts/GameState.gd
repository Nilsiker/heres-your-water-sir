extends Node

signal glass_spawned
signal glass_held(glass: Glass)
signal glass_dropped(glass: Glass)
signal glass_shattered(glass: Glass)
signal gulped(glass: Glass)
signal choked
signal recovered
signal glass_finished

var combination: String
var glass_count: int = 0

func _ready():
	get_tree().current_scene.get_node("WaterTimer").timeout.connect(_on_water_timer_timeout)
	
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
	print("TODO implement choke on liquid visual effect or cough")
	choked.emit()

func shatter_glass(glass: Glass):
	glass_count -= 1
	glass_shattered.emit(glass)
			
func start():
	get_tree().current_scene.get_node("Menu").queue_free()
	get_tree().current_scene.get_node("WaterTimer").start()
	
func recover():
	recovered.emit()
