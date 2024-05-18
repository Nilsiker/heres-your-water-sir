class_name Hand
extends Node2D

@export_range(0, 5) var offset_x_range: float

var water: PackedScene = preload ("res://scenes/glass/glass.tscn")

@onready var target_pos: Vector2 = %HandOriginalPosition.global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.glass_spawned.connect(_on_glass_spawned)

func _physics_process(delta):
	global_position = Vector2(round(target_pos.x), round(target_pos.y))

var tween: Tween
func _on_glass_spawned():
	var random_offset = randf_range( - offset_x_range, offset_x_range)

	var glass = water.instantiate() as Glass
	glass.name = "Glass"
	glass.freeze = true
	$GlassPosition.add_child(glass)
	
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "target_pos", %Table.get_new_glass_position() + Vector2(random_offset, 0), 1.5)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func(): drop_glass(glass))

var back_tween: Tween
func drop_glass(glass):
	if back_tween: back_tween.kill()
	glass.reparent( %Table.get_node("Glasses"))
	glass.freeze = false
	back_tween = get_tree().create_tween()
	back_tween.set_ease(Tween.EASE_IN_OUT)
	back_tween.tween_property(self, "target_pos", %HandOriginalPosition.global_position, 0.25)
