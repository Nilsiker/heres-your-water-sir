extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.game_started.connect(on)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on():
	$Buzz.play()
	$Click.play()
	$AnimationPlayer.play("Lit")


func off():
	$Click.play()
	$Buzz.stop()
	$AnimationPlayer.play("Unlit")