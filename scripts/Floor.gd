extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_crash_area_body_entered(body:Node2D):
	if body is Glass:
		body.shatter(body.global_position)	# todo refine pos (physicsserver?)
