extends Node

signal rumbling_updated(intensity: float)
signal roared(intensity: float)

func roar():
	GameState.upset(0.15)
	roared.emit()

func update_rumble(rumbling):
	rumbling_updated.emit(rumbling)