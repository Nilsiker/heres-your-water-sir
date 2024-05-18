class_name Glass
extends RigidBody2D

@export var key: String
@export var is_water: bool
@export var amount = 3.0
@export var gulp_amount: float

@onready var shatter_particles = preload("res://scenes/particles/shatter_particles.tscn")
@onready var particles_material = preload("res://scenes/particles/shatter_particles.tres")

func _ready():
	key = _get_random_key()
	is_water = randf() > 0.5
	if not is_water:
		var c = Color.YELLOW
		c.a = 0.5
		$LiquidSprite.modulate = c
	gulp_amount = 1



func gulp():
	amount = max(0, amount-gulp_amount)
	if $LiquidSprite.region_rect.size.y:
		$LiquidSprite.region_rect.size.y = amount
	key = _get_random_key() if amount else ""


func _get_random_key() -> String:
	var lower_case = GameState.glass_drunk > 5 and randf() > 0.5
	if randi() % 2 == 0:
		if lower_case: return "q"
		else: return "Q"
	else:
		if lower_case: return "a"
		else: return "A"


func shatter():
	var particles = shatter_particles.instantiate() as GPUParticles2D
	particles.process_material = particles_material.duplicate(true)
	get_tree().current_scene.get_node("Shards").add_child(particles)
	particles.global_position = global_position
	
	var gradient: Gradient = particles.process_material.color_initial_ramp.gradient as Gradient
	gradient.set_color(0, $LiquidSprite.modulate)
	gradient.set_offset(1, $LiquidSprite.region_rect.size.y / 6)

	particles.amount = 10 + 10  *  $LiquidSprite.region_rect.size.y / 3
	particles.emitting = true
	particles.finished.connect(particles.queue_free)
	DrinkChannel.shatter(self)
	queue_free()
