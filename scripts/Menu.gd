extends CanvasLayer

var quit_held: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true

func _process(delta):
	$Margins/Quitting.visible = quit_held
	if Input.is_key_pressed(KEY_ESCAPE):
		$Margins/Quitting/Progress.value = quit_held
		quit_held += delta
	else: 
		quit_held = 0
	if quit_held > 1:
		match GameState.state:
			GameState.State.Menu:
				get_tree().quit()
			_:
				get_tree().change_scene_to_file("res://scenes/game.tscn")
				GameState.state = GameState.State.Menu	# todo ugly!



func play():
	$Margins/Menu.visible = false
	GameState.start_sequence()
	
func quit():
	get_tree().quit()

func _unhandled_input(event):
	if not $Margins/Menu.visible: return
	if event.is_action_pressed("A"):
		play()
	elif event.is_action_pressed("Q"):
		quit()
