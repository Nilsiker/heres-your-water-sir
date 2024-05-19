class_name Hand
extends Node2D

@export_range(0, 5) var offset_x_range: float

var water: PackedScene = preload ("res://scenes/glass/glass.tscn")

@onready var target_pos: Vector2 = %HandOriginalPosition.global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	DrinkChannel.spawned.connect(_on_glass_spawned)
	DrinkChannel.shattered.connect(_on_glass_shattered)
	DrinkChannel.choked.connect(_on_player_choked)
	MonsterChannel.roared.connect(_on_roar)

func _physics_process(_delta):
	global_position = Vector2(round(target_pos.x), round(target_pos.y))

var tween: Tween
func _on_glass_spawned():
	if not GameState.state == GameState.State.Chained: return
	if (tween and tween.is_running()) or (back_tween and back_tween.is_running()): return
	var random_offset = randf_range( - offset_x_range, offset_x_range) if GameState.allow_sloppy_monster else 0.0

	var glass = water.instantiate() as Glass
	glass.name = "Glass"
	glass.freeze = true
	$GlassPosition.add_child(glass)
	
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "target_pos", %Table.get_new_glass_position() + Vector2(random_offset, 0), 1.75 - (GameState.upset_amount))
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func():
		drop_glass(glass)
	)
	_start_crackling()

func _on_player_choked():
	var timer = get_tree().create_timer(.50)
	timer.timeout.connect(MonsterChannel.roar)

func _on_glass_shattered(glass: Glass):
	if not GameState.state == GameState.State.Chained: return
	if glass.is_water and glass.amount > 0:
		var timer = get_tree().create_timer(.25)
		timer.timeout.connect(MonsterChannel.roar)

func _on_roar():
	var filter = AudioServer.get_bus_effect(2, 1) as AudioEffectLowPassFilter
	filter.cutoff_hz = 1000 * (1 + GameState.upset_amount)
	$ScreamAudio.volume_db = -12.0 + GameState.upset_amount
	$RoarAudio.pitch_scale = 1 + GameState.upset_amount
	$ScreamAudio.play()
	$RoarAudio.play()

var back_tween: Tween
func drop_glass(glass):
	if back_tween: back_tween.kill()
	glass.reparent( %Table.get_node("Glasses"))
	glass.freeze = false
	back_tween = get_tree().create_tween()
	back_tween.set_ease(Tween.EASE_IN_OUT)
	back_tween.tween_property(self, "target_pos", %HandOriginalPosition.global_position, 0.25)
	back_tween.tween_callback(_stop_crackling)
	_start_crackling()

func _stop_crackling():
	$CracklingLimbsAudio.stop()

func _start_crackling():
	$CracklingLimbsAudio.pitch_scale = randf_range(0.8, 1.2)
	$CracklingLimbsAudio.play()
	$RumblingAudio.play()

func rumble(intensity):
	MonsterChannel.update_rumble(intensity)
