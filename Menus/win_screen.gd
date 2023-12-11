extends EventScene

var main_scene_path = "res://world.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_MainMenuButton_pressed():
	get_tree().change_scene_to_file(main_scene_path)

func _on_QuitButton_pressed():
	get_tree().quit()
