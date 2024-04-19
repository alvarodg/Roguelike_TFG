extends Node2D
class_name SlashAnimation

signal finished

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("use")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "use":
		finished.emit()
		queue_free()

