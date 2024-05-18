extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	DrinkChannel.spawned.connect(add_water)
	DrinkChannel.shattered.connect(remove_water)

func add_water():
	text = str(int($"../WaterCounter".text) + 1)

func remove_water(_glass: Glass):
	text = str(int($"../WaterCounter".text) - 1)
