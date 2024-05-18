class_name Glass
extends RigidBody2D

@export var combination: String
@export var is_water: bool
@export var amount = 3
@export var gulp_amount: float

@onready var shatter_particles = preload("res://scenes/shatter_particles.tscn")

func _ready():
	combination = _get_random_combo()
	is_water = randf() > 0.5
	if not is_water:
		$LiquidSprite.modulate = Color.SADDLE_BROWN
	gulp_amount = 3.0 / combination.length()

func gulp():
	combination = combination.substr(1)
	print($LiquidSprite.region_rect.size.y)
	if $LiquidSprite.region_rect.size.y:
		$LiquidSprite.region_rect.size.y -= gulp_amount
	
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
	var particles = shatter_particles.instantiate() as CPUParticles2D
	get_tree().current_scene.add_child(particles)
	particles.global_position = at_position
	particles.color_initial_ramp.set_color(0, $LiquidSprite.modulate)
	particles.color_initial_ramp.set_offset(1, $LiquidSprite.region_rect.size.y / 6)
	particles.amount = 10 + 10  *  $LiquidSprite.region_rect.size.y / 3
	particles.emitting = true
	particles.finished.connect(particles.queue_free)
	GameState.shatter_glass(self)
	queue_free()