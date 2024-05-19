extends Sprite2D

@export var _speed = 8
var holding: Glass

# Called when the node enters the scene tree for the first time.
func _ready():
	holding = null
	DrinkChannel.choked.connect(_on_choke)
	MonsterChannel.roared.connect(_on_monster_roared)

	$CoughTimer.timeout.connect(_on_choke_ended)
	$AnimationPlayer.animation_finished.connect(func(_anim): $AnimationPlayer.play("Sit"))

func _process(delta):# FREED
	if GameState.state == GameState.State.Free:
		offset.y = 4
		var direction = Input.get_axis("left", "right")
		if direction:
			if direction > 0:
				flip_h = false
			if direction < 0:
				flip_h = true
			$AnimationPlayer.play("Walk")
			global_position.x += direction * delta * _speed
		else:
			$AnimationPlayer.play("Idle")

		

func _on_monster_roared():
	$AnimationPlayer.speed_scale = 1 + GameState.upset_amount

func _on_choke():
	$CoughTimer.start()
	$AnimationPlayer.play("Choke")
	$CoughAudio.play()

func _gulp():
	if $AnimationPlayer.current_animation == "Sit":
		$AnimationPlayer.play("Drink")
	
func _on_anim_gulp():
	holding.gulp()
	DrinkChannel.gulp(holding)
	if not holding.is_water: MonsterChannel.roar()
	if holding.amount:
		$GulpAudio.play()
	else:
		if holding.is_water: GameState.increment_score()
		$FinishedAudio.play()

func _on_anim_gulp_finished():
	pass

func _on_choke_ended():
	GameState.recover()
	$AnimationPlayer.play("Sit")
	
func _unhandled_input(event):
	# CHAINED
	if GameState.state == GameState.State.Chained:
		if $CoughTimer.time_left: return
		
		var glass = %Table.get_next_glass() as Glass
		if event.is_action_pressed("U"):
			if holding:
				DrinkChannel.drop(holding)
				$AnimationPlayer.play("Sit")
				holding.freeze = false
				holding = null
				return

			if glass:
				holding = glass
				DrinkChannel.hold(glass)
				glass.reparent($GlassPosition)
				glass.position = Vector2.ZERO
				glass.freeze = true

		elif event.is_action_pressed("Q"):
			if holding and holding.key.to_upper() == "Q":
				_gulp()
			else:
				DrinkChannel.choke()

		elif event.is_action_pressed("A"):
			if holding and holding.key.to_upper() == "A":
				_gulp()
			else:
				DrinkChannel.choke()