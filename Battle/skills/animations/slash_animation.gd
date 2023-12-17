extends Node2D
class_name SlashAnimation

@onready var animation_player = $AnimationPlayer

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "use":
		queue_free()
