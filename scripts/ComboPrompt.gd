class_name ComboPrompt
extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.glass_held.connect(set_combo_label)
	GameState.gulped.connect(set_combo_label)
	GameState.choked.connect(_on_disable)
	GameState.recovered.connect(_on_enable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_combo_label(glass: Glass):
	if glass.combination:
		text = glass.combination[0]
	else: text = "U"

func _on_disable():
	self_modulate = Color.WHITE / 2

	
func _on_enable():
	self_modulate = Color.WHITE
	
