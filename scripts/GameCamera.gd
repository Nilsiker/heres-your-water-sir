extends Camera2D

# screen shake functions taken from https://kidscancode.org/godot_recipes/3.x/2d/screen_shake/index.html

@export var decay_time = 2 # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75) # Maximum hor/ver shake in pixels.

var _trauma = 0.0 # Current shake strength.
var _trauma_power = 3 # Trauma exponent. Use [2, 3].
var _rumbling: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	MonsterChannel.roared.connect(_on_monster_roared)
	MonsterChannel.rumbling_updated.connect(_on_monster_rumble_updated)
	
func _on_monster_rumble_updated(intensity):
	_rumbling = intensity

func _on_monster_roared():
	#_trauma = min(_trauma + 0.4, 1.0)
	_trauma = min(GameState.upset_amount, 0.5)

func _process(delta):
	if _trauma > 0:
		var decay_rate = 0.5 / decay_time
		_trauma = max(_trauma - decay_rate * delta, _rumbling)
		shake()
		
func shake():
	var amount = pow(_trauma, _trauma_power)
	offset.x = max_offset.x * amount * randf_range( - 1, 1)
	offset.y = max_offset.y * amount * randf_range( - 1, 1)