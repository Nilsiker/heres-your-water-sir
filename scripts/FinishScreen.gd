extends CanvasLayer

@export var scroll: ScrollContainer
@export var _delay = 3.0
@export var _speed = 5.0

var scrolling = false
var target_scroll = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	scroll.scroll_vertical = target_scroll
	if scrolling:
		target_scroll = target_scroll + (delta*_speed)

func _on_visible():
	get_tree().create_timer(_delay).timeout.connect(start_scrolling)

func start_scrolling():
	scrolling = true

func _input(event):
	if visible and target_scroll > scroll.scroll_vertical and event.is_action_pressed("continue"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
