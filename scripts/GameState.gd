extends Node

signal water_spawned
signal water_held
signal water_gulped
signal gulp_failed
signal water_finished


var water_count: int = 0
var water_combination: String

func _ready():
	get_tree().current_scene.get_node("WaterTimer").timeout.connect(_on_water_timer_timeout)
	
func _on_water_timer_timeout():
	water_spawned.emit()
	water_count += 1
	
func hold_water():
	if not water_count: return
	water_combination = get_random_combo()
	water_held.emit(water_combination)


func gulp_water(key: String):
	if not water_combination: 
		gulp_failed.emit()
		return
	if not key == water_combination[0].to_upper(): 
		gulp_failed.emit()		
		return
	
	water_combination = water_combination.substr(1)
	water_gulped.emit(water_combination)
	if not water_combination:
		water_count -= 1
		water_finished.emit()
	return


func get_random_combo() -> String:
	var difficulty = 6 # todo
	var combo = ""
	for i in difficulty:
		var lower_case = difficulty / 20.0 > randf()
		if randi() % 2 == 0:
			if lower_case: combo += "q"
			else: combo += "Q"
		else:
			if lower_case: combo += "a"
			else: combo += "A"
	return combo
			
			


