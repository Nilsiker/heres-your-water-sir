class_name ComboPrompt
extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	DrinkChannel.spawned.connect(_on_spawned)
	DrinkChannel.held.connect(set_combo_label)
	DrinkChannel.dropped.connect(_on_glass_dropped)
	DrinkChannel.gulped.connect(set_combo_label)
	DrinkChannel.choked.connect(_on_disable)
	GameState.recovered.connect(_on_enable)
	GameState.free_player_sequence_started.connect(func(): text = "")


var modulate_tween: Tween
var shadow_tween: Tween

func _on_spawned():
	if GameState.waters_drunk == 0:
		get_tree().create_timer(4.0).timeout.connect(func(): 
			if text.is_empty():
				text = "U"
				modulate.a = 0.5
		)

func _on_glass_dropped(_glass: Glass):
	text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_combo_label(glass: Glass):
	if glass.key:
		text = glass.key
	else: text = ""

	modulate.a = 1

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
