extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.water_spawned.connect(add_water)
	GameState.water_finished.connect(remove_water)

func add_water():
	text = str(int($"../WaterCounter".text) + 1)

func remove_water():
	text = str(int($"../WaterCounter".text) - 1)
