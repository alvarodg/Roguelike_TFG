extends Node
## Guarda los objetos y habilidades que estarán disponibles en la partida.
## TODO: Reorganizar responsabilidades?
class_name CollectionContainer

@export var equipments: EquipmentCollection
@export var skills: SkillCollection
@export var events: EventCollection

# Called when the node enters the scene tree for the first time.
func _ready():
	RunData.collections = self
	EventBus.equipment_equipped.connect(_on_equipment_equipped)
	add_to_group("equipment_list")
	add_to_group("run_persistent")
	
# Saca un equipamiento de equip_list, modifica la lista. ¿Mover a su propia clase?
func _get_random_equipment(equip_list: Array[Equipment], rarity: int = -1, rarity_factor: float = 0.0) -> Equipment:
	if equip_list.size() == 0:
		return null
	var pickable_list: Array[Equipment] = []
	if rarity > 0:
		for equipment in equip_list:
			if equipment.rarity == rarity:
				pickable_list.append(equipment)
		var chosen = pickable_list.pick_random()
		equip_list.erase(chosen)
		return chosen
	else:
		#TEMPORAL, ignora rarity
		var chosen: Equipment
		var total_chance = 0.0
		for equipment in equip_list:
			total_chance += 1/(1 + equipment.rarity * rarity_factor)
		var current_chance = 0.0
		var roll = randf_range(0,total_chance)
		for i in range(equip_list.size()):
			current_chance += 1/(1 + equip_list[i].rarity * rarity_factor)
			if current_chance >= roll:
				chosen = equip_list[i]
				break
		equip_list.erase(chosen)
		return chosen


#func get_random_equipment_list(size: int = 1, rarity: int = -1) -> Array[Equipment]:
#	var list: Array[Equipment] = equipments.list.duplicate()
#	var picks: int = min(size, list.size())
#	var chosen_list: Array[Equipment] = []
#	for i in range(picks):
#		var chosen_equipment = _get_random_equipment(list, rarity)
#		if chosen_equipment != null:
#			chosen_list.append(chosen_equipment)
#	return chosen_list

## TODO: ¿Modificar con rarity? Comparte mucho con la función de equipment, ¿función genérica?
#func get_random_skill_list(size: int = 1) -> Array[SkillData]:
#	var list: Array[SkillData] = skills.list.duplicate()
#	var picks: int = min(size, list.size())
#	var chosen_list: Array[SkillData] = []
#	for i in range(picks):
#		var chosen_skill = list.pick_random()
#		if chosen_skill != null:
#			chosen_list.append(chosen_skill)
#			list.erase(chosen_skill)
#	return chosen_list

func get_random_equipment_list(size: int = 1, tags: Array[Equipment.Tag] = [],
 op: Collection.Operator = Collection.Operator.OR, rarity_pick: Array[int] = [], 
 rarity_factor: float = 1) -> Array:
	return _get_random_list(equipments, size, tags, op, rarity_pick, rarity_factor)
	
func get_random_skill_list(size: int = 1, tags: Array[SkillData.Tag] = [],
 op: Collection.Operator = Collection.Operator.OR, rarity_pick: Array[int] = [], 
 rarity_factor: float = 1) -> Array:
	return _get_random_list(skills, size, tags, op, rarity_pick, rarity_factor)
	
func get_random_event_list(size: int = 1, tags: Array[EventData.Tag] = [],
 op: Collection.Operator = Collection.Operator.OR, rarity_pick: Array[int] = [], 
 rarity_factor: float = 1) -> Array:
	return _get_random_list(events, size, tags, op, rarity_pick, rarity_factor)

# Posiblemente mover a Collection	
func _get_random_list(p_collection: Collection, size: int = 1, tags: Array = [],
 op: Collection.Operator = Collection.Operator.OR, rarity_pick: Array[int] = [], 
 rarity_factor: float = 1) -> Array:
	# Duplica la colección para poder sacar elementos temporalmente.
	var collection: Collection = p_collection.duplicate()
	var picks: int = min(size, collection.size())
	var chosen_list: Array = []
	for i in range(picks):
		var chosen = collection.get_random(RunData.rng, tags, op, rarity_pick, rarity_factor)
		if chosen != null:
			chosen_list.append(chosen)
			collection.remove(chosen)
	return chosen_list
	
	
func get_random_event(rarity_factor = 1) -> EventData:
	return events.get_random(rarity_factor)

func add(element):
	if element is Equipment:
		equipments.add(element)
	elif element is SkillData:
		skills.add(element)
	elif element is EventData:
		events.add(element)


#func remove_equipment(equipment: Equipment):
#	equipments.list.erase(equipment)
#
#func remove_skill(skill: SkillData):
#	skills.list.erase(skill)

func remove(element):
	if element is Equipment:
		equipments.remove(element)
	elif element is SkillData:
		skills.remove(element)
	elif element is EventData:
		events.remove(element)
		

func _on_equipment_equipped(equipment: Equipment):
	remove(equipment)

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
	}
	# Guarda y carga por nombre del archivo de los recursos.
	# TEMPORAL? Necesario cambiarlo para poder aceptar múltiples objetos iguales.
	var equipment_paths: Array[String] = []
	var skill_paths: Array[String] = []
	var event_paths: Array[String] = []
	for equipment in equipments.list:
		equipment_paths.append(equipment.resource_path)
	for skill in skills.list:
		skill_paths.append(skill.resource_path)
	for event in events.list:
		event_paths.append(event.resource_path)
	save_dict["equipments"] = equipment_paths
	save_dict["skills"] = skill_paths
	save_dict["events"] = event_paths
	return save_dict
	
func data_load(parameter, data):
	if parameter == "equipments":
		var equip_list: Array[Equipment] = []
		for equipment_path in data:
			equip_list.append(load(equipment_path))
		equipments = EquipmentCollection.new(equip_list)
	elif parameter == "skills":
		var skill_list: Array[SkillData] = []
		for skill_path in data:
			skill_list.append(load(skill_path))
		skills = SkillCollection.new(skill_list)
	elif parameter == "events":
		var event_list: Array[EventData] = []
		for event_path in data:
			event_list.append(load(event_path))
		events = EventCollection.new(event_list)
	else:
		set(parameter, data)
