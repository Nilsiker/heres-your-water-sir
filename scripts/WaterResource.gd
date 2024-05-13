class_name WaterResource
extends Resource

@export var combination: String

func pop():
	combination.substr(1)
	
func peek() -> String:
	return combination[0]
