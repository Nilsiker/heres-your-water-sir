class_name ComboPrompt
extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.glass_held.connect(set_combo_label)
	GameState.gulped.connect(set_combo_label)
	GameState.choked.connect(_on_disable)
	GameState.recovered.connect(_on_enable)

var modulate_tween: Tween
var shadow_tween: Tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_combo_label(glass: Glass):
	if glass.combination:
		text = glass.combination[0]
	elif GameState.glass_count > 0: text = "U"
	else: text = ""

	if modulate_tween: modulate_tween.kill()
	if shadow_tween: shadow_tween.kill()
	modulate_tween = get_tree().create_tween()
	shadow_tween = get_tree().create_tween()
	add_theme_constant_override("shadow_outline_size", 16)
	modulate = Color.TRANSPARENT
	modulate_tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	shadow_tween.tween_property(self, "theme_override_constants/shadow_outline_size", 0, .25)

func _on_disable():
	self_modulate = Color.WHITE / 2

	
func _on_enable():
	self_modulate = Color.WHITE
	
