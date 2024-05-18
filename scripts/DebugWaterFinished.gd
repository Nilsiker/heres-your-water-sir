extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.water_drunk_updated.connect(func(count): text = str(count))

