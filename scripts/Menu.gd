extends CanvasLayer

@export var help: Control
@export var credits: ScrollContainer
@export var _credits_scroll_speed: float = 10.0
@export var particles: CPUParticles2D

var target_scroll = 0
var quit_held: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true

func _process(delta):
	if credits.visible:
		credits.scroll_vertical = target_scroll
		target_scroll += _credits_scroll_speed * delta
	particles.emitting = $Margins/Menu.visible
	$Margins/Quitting.visible = quit_held
	if Input.is_key_pressed(KEY_ESCAPE):
		$Margins/Quitting/Progress.value = quit_held
		quit_held += delta
	else:
		quit_held = 0
	if quit_held > 1:
		match GameState.state:
			GameState.State.Menu:
				get_tree().quit()
			_:
				get_tree().change_scene_to_file("res://scenes/game.tscn")
				GameState.state = GameState.State.Menu # todo ugly!

func play():
	$Margins/Menu.visible = false
	$Margins/Warning.visible = false
	
	GameState.start_sequence()

func show_credits():
	credits.visible = true
	target_scroll = 0
	help.visible = false

func show_help():
	help.visible = true if not help.visible else false
	credits.visible = false
	
func quit():
	get_tree().quit()
