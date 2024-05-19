extends Camera2D

# screen shake functions taken from https://kidscancode.org/godot_recipes/3.x/2d/screen_shake/index.html

@export var decay_time = 2 # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75) # Maximum hor/ver shake in pixels.

var _trauma = 0.0 # Current shake strength.
var _trauma_power = 3 # Trauma exponent. Use [2, 3].
var _rumbling: float = 0.0

var _target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	MonsterChannel.roared.connect(_on_monster_roared)
	MonsterChannel.rumbling_updated.connect(_on_monster_rumble_updated)
	GameState.player_freed.connect(_on_player_freed)


func _on_monster_rumble_updated(intensity):
	_rumbling = intensity

func _on_monster_roared():
	#_trauma = min(_trauma + 0.4, 1.0)
	_trauma = min(GameState.upset_amount, 0.5)

func _on_player_freed():
	_target = %Player/CameraPosition
	zoom = Vector2.ONE * 8
	position = Vector2.ZERO

func _process(delta):
	if _trauma > 0:
		var decay_rate = 0.5 / decay_time
		_trauma = max(_trauma - decay_rate * delta, _rumbling)
		shake()
	
	if _target:
		global_position = _target.global_position
		
func shake():
	var amount = pow(_trauma, _trauma_power)
	offset.x = max_offset.x * amount * randf_range( - 1, 1)
	offset.y = max_offset.y * amount * randf_range( - 1, 1)