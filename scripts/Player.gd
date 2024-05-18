extends Sprite2D

var holding: Glass = null
var fullness = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$CoughTimer.timeout.connect(_on_choke_ended)
	GameState.choked.connect(_on_choke)

	$AnimationPlayer.animation_finished.connect(func(_anim): $AnimationPlayer.play("Sit"))

func _on_choke():
	$CoughTimer.start()
	$AnimationPlayer.play("Choke")
	$CoughAudio.play()

func _gulp():
	if $AnimationPlayer.current_animation == "Sit":
		$AnimationPlayer.play("Drink")
	
func _on_anim_gulp():
	holding.gulp(fullness)
	fullness += 0.1
	GameState.gulp(holding)
	if holding.amount:
		$GulpAudio.play()
	else:
		GameState.increment_score()
		$FinishedAudio.play()

func _on_anim_gulp_finished():
	pass

func _on_choke_ended():
	GameState.recover()
	$AnimationPlayer.play("Sit")
	
func _unhandled_input(event):
	if not GameState.state == GameState.State.Chained: return
	if $CoughTimer.time_left: return
	
	var glass = %Table.get_next_glass() as Glass
	if event.is_action_pressed("U"):
		if holding:
			GameState.drop_glass(holding)
			$AnimationPlayer.play("Sit")
			holding.freeze = false
			holding = null
			return

		if glass:
			holding = glass
			GameState.hold_glass(glass)
			glass.reparent($GlassPosition)
			glass.position = Vector2.ZERO
			glass.freeze = true

	elif event.is_action_pressed("Q"):
		if holding and holding.key.to_upper() == "Q":
			_gulp()
		else:
			GameState.choke(holding)

	elif event.is_action_pressed("A"):
		if holding and holding.key.to_upper() == "A":
			_gulp()
		else:
			GameState.choke(holding)
