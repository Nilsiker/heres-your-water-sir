extends Node2D

func _ready():
	$AnimationPlayer.play("Lit")
	visible = false

func on():
	visible = true
	$Click.play()