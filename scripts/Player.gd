extends Sprite2D



# Called when the node enters the scene tree for the first time.
func _ready():
	$CoughTimer.timeout.connect(GameState.stop_cough)
	GameState.gulp_failed.connect(func(): $CoughTimer.start())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func _unhandled_input(event):
	if $CoughTimer.time_left: return
	
	if event.is_action_pressed("U"):
		GameState.hold_water()
	elif event.is_action_pressed("Q"):
		GameState.gulp_water("Q")
	elif event.is_action_pressed("A"):
		GameState.gulp_water("A")
		
