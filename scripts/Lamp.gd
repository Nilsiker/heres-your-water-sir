extends Sprite2D

@export var flicker_max = 0.8
var flicker_target = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.game_started.connect(on)
	GameState.player_freed.connect(off_but_flashlight)
	GameState.free_player_sequence_started.connect(func(): GameState.allow_lamp_flickering = false)
	$AnimationPlayer.play("Unlit")
	$Timer.timeout.connect(flicker)

func _process(delta):
	$Flicker.color.a = move_toward($Flicker.color.a, flicker_target, 2 * delta)


func on():
	$Buzz.play()
	$Click.play()
	$AnimationPlayer.play("Lit")

func flicker():
	if GameState.allow_lamp_flickering:
		$Timer.wait_time = 0.1
		flicker_target = randf_range(0.2, flicker_max) if not $Flicker.color.a else 0.0

func off():
	$Click.play()
	$Buzz.stop()
	$AnimationPlayer.play("Unlit")

func off_but_flashlight():
	$AnimationPlayer.play("Flashlight")