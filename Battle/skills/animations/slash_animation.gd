extends Node2D
class_name SlashAnimation

signal finished

@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player = $AudioStreamPlayer

var sounds = SystemData.sound_collection

func _ready():
	animation_player.play("use")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "use":
		finished.emit()
		queue_free()

func _play_sound():
	audio_stream_player.stream = sounds.get_regular_hit()
	audio_stream_player.play()
