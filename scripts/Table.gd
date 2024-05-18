extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_next_glass() -> Glass:
	if $Glasses.get_children():
		return $Glasses.get_child(0) as Glass
	return null

func get_new_glass_position() -> Vector2:
	var position_path = "Positions/"+str(GameState.glass_count % 5)
	var node = get_node(position_path)
	return node.global_position