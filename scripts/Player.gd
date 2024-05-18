extends Sprite2D

var holding: Glass = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$CoughTimer.timeout.connect(GameState.recover)
	GameState.choked.connect(func(): $CoughTimer.start())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _unhandled_input(event):
	if $CoughTimer.time_left: return
	
	var glass = %Table.get_next_glass() as Glass
	if event.is_action_pressed("U"):
		if holding: 
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
		if holding and holding.peek() == "Q":			
			holding.pop()
			GameState.gulp(holding)
		else:
			GameState.choke(holding)

	elif event.is_action_pressed("A"):
		if holding and  holding.peek() == "A":
			holding.pop()
			GameState.gulp(holding)
		else:
			GameState.choke(holding)
		
