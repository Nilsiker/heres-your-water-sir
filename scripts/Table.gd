extends Sprite2D

var water: PackedScene = preload("res://scenes/water.tscn")
@export_range(0,5) var offset_x_range: float

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.water_spawned.connect(_on_put_on_table)
	GameState.water_finished.connect(_on_water_drank)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_put_on_table():
	var new_water = water.instantiate()
	$Placement.add_child(new_water)
	new_water.position.x += randf_range(-offset_x_range,offset_x_range) * 3
	
func _on_water_drank():
	if $Placement.get_children():
		$Placement.get_children()[0].queue_free()
	
