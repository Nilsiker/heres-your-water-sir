extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true

func play():
	visible = false
	GameState.start_sequence()
	
func quit():
	get_tree().quit()

func _unhandled_input(event):
	if not visible: return
	if event.is_action_pressed("A"):
		play()
	elif event.is_action_pressed("Q"):
		quit()
