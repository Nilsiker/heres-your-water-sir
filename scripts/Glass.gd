class_name Glass
extends RigidBody2D

@export var combination: String
@export var is_water: bool

@onready var shatter_particles = preload("res://scenes/shatter_particles.tscn")

func _ready():
	combination = _get_random_combo()
	is_water = true

func pop():
	combination = combination.substr(1)
	
func peek() -> String:
	return combination[0].to_upper() if not combination.is_empty() else ""


func _get_random_combo() -> String:
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

func shatter(at_position: Vector2):
	var particles = shatter_particles.instantiate()
	get_tree().current_scene.add_child(particles)
	particles.global_position = at_position
	particles.emitting = true
	particles.finished.connect(particles.queue_free)
	GameState.shatter_glass(self)
	queue_free()
