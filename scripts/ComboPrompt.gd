class_name ComboPrompt
extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.water_held.connect(set_combo_label)
	GameState.water_gulped.connect(set_combo_label)
	GameState.gulp_failed.connect(_on_disable)
	GameState.cough_stopped.connect(_on_enable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_combo_label(label):
	text = label

func _on_disable():
	self_modulate = Color.WHITE / 2

	
func _on_enable():
	self_modulate = Color.WHITE
	
