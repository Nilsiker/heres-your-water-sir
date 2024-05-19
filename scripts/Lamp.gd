extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.game_started.connect(on)
	GameState.player_freed.connect(off_but_flashlight)
	$AnimationPlayer.play("Unlit")


func on():
	$Buzz.play()
	$Click.play()
	$AnimationPlayer.play("Lit")


func off():
	$Click.play()
	$Buzz.stop()
	$AnimationPlayer.play("Unlit")

func off_but_flashlight():
	$AnimationPlayer.play("Flashlight")