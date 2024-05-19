extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_crash_area_body_entered)
	GameState.game_started.connect(remove_shards)
	GameState.player_freed.connect(queue_free)


func remove_shards():
	for child in get_children():
		if child is GPUParticles2D: child.queue_free()

func _on_crash_area_body_entered(body:Node2D):
	if body is Glass:
		body.shatter()
