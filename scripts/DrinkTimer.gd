extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
		GameState.game_started.connect(_on_start)

func _on_start():
	wait_time = 8
	start()