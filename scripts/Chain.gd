extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.game_started.connect(func(): $AnimationPlayer.play("on"))
	GameState.player_freed.connect(func(): $AnimationPlayer.play("off"))
