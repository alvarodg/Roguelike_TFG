extends CanvasLayer

signal transition_finished

# Transiciones basadas en las del tutorial "Heart Platformer" de Heartbeast.
# https://www.youtube.com/watch?v=M8-JVjtJlIQ&list=PL9FzW-m48fn0i9GYBoTY-SI3yOBZjH1kJ&pp=iAQB

@onready var animation_player = $AnimationPlayer

func fade_from_black(speed_factor: float = 1.0):
	animation_player.play("fade_from_black", -1, speed_factor)
	await animation_player.animation_finished
	transition_finished.emit()
	
func fade_to_black(speed_factor: float = 1.0):
	animation_player.play("fade_to_black", -1, speed_factor)
	await animation_player.animation_finished
	transition_finished.emit()
