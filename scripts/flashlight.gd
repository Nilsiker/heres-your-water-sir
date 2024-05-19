extends Node2D

func _ready():
	$AnimationPlayer.play("Lit")
	($Area2D as Area2D).body_entered.connect(_on_body_entered)
	($Area2D as Area2D).body_exited.connect(_on_body_exited)
	visible = false
	$Label.visible = false

func _process(_delta):
	if get_parent().name == "HandSocket":
		$Sprite2D.flip_h = get_parent().get_parent().get_node("Sprite").flip_h

func on():
	visible = true
	$Click.play()

func use(user: Node):
	$Body.queue_free()
	$Label.queue_free()
	$Area2D.queue_free()
	reparent(user.get_node("HandSocket"))
	z_index = 8
	position = Vector2.ZERO
	global_rotation_degrees = 180

func _on_body_entered(body):
		print(body)
		$Label.visible = body is Player

func _on_body_exited(body):
	if body is Player:
		$Label.visible = false

func _unhandled_input(event): # eww, but stressed!
	if get_parent().name == "HandSocket": return
	if GameState.state == GameState.State.Free and event.is_action_pressed("U") and $Label.visible:
		use(%Player)