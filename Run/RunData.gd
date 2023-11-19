extends Node
# Funciones save_game y load_game de la documentación de Godot, modificadas.

var version = "0.1"
var run_seed = 0
var player: Player
var collections: CollectionContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the run_persistent category and ask them to return a
# dict of relevant variables.
func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("run_persistent")
	
	# Guarda los datos de la partida
	var run_data_dict = {
		"version" : version,
		"run_seed" : run_seed,
	}
#	run_data_dict.merge(player.to_save_dict())
	save_file.store_line(JSON.stringify(run_data_dict))
#	save_file.store_line(JSON.stringify(player.to_save_dict()))
	# Guarda los datos del grupo "run_persistent"
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("run_persistent")
	for i in save_nodes:
		i.queue_free()
		
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	# Creates the helper class to interact with JSON
	var json = JSON.new()
	# Carga los datos de la partida
	if json.parse(save_file.get_line()) == OK:
		var run_data_dict = json.get_data()
		version = run_data_dict["version"]
		run_seed = run_data_dict["run_seed"]
	# Carga el resto de los datos del grupo "run_persistent"
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		json = JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		# Comprueba si el nodo tiene una posición guardada, si no se salta esta asignación.
		if "pos.x" in node_data.keys():
			new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			if new_object.has_method("data_load"):
				new_object.data_load(i, node_data[i])
			else:
				new_object.set(i, node_data[i])

## Comprueba la validez de la partida guardada. 
## Esta implementación asume que se actualizará la versión cuando se realicen cambios que 
## puedan afectar a partidas previas.
func is_save_compatible() -> bool:
	var valid = true
	if FileAccess.file_exists("user://savegame.save"):
		var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
		var json = JSON.new()
		# Carga los datos de la partida
		if json.parse(save_file.get_line()) == OK:
			var run_data_dict = json.get_data()
			valid = run_data_dict["version"] == version
	return valid

func save_exists() -> bool:
	return FileAccess.file_exists("user://savegame.save")


func stash_save():
	if FileAccess.file_exists("user://savegame.save"):
		var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
		var json = JSON.new()
		# Carga los datos de la partida
		if json.parse(save_file.get_line()) == OK:
			var run_data_dict = json.get_data()
			var backup_file_path = "user://savegame"+ str(run_data_dict["version"]) + ".save"
			DirAccess.copy_absolute("user://savegame.save", backup_file_path)
