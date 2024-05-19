extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_crash_area_body_entered)
	GameState.player_freed.connect(queue_free)


func _on_crash_area_body_entered(body:Node2D):
	if body is Glass:
		body.shatter()
