extends Node
## Guarda los objetos y habilidades que estarán disponibles en la partida.
## TODO: Reorganizar responsabilidades?
class_name CollectionContainer

@export var equipments: EquipmentCollection
@export var skills: SkillCollection

# Called when the node enters the scene tree for the first time.
func _ready():
	RunData.collections = self

# Saca un equipamiento de equip_list, modifica la lista. ¿Mover a su propia clase?
func _get_random_equipment(equip_list: Array[Equipment], rarity: int = -1) -> Equipment:
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
		var chosen = equip_list.pick_random()
		equip_list.erase(chosen)
		return chosen


func get_random_equipment_list(size: int = 1, rarity: int = -1) -> Array[Equipment]:
	var list: Array[Equipment] = equipments.list.duplicate()
	var picks: int = min(size, list.size())
	var chosen_list: Array[Equipment] = []
	for i in range(picks):
		var chosen_equipment = _get_random_equipment(list, rarity)
		if chosen_equipment != null:
			chosen_list.append(chosen_equipment)
	return chosen_list

# TODO: ¿Modificar con rarity? Comparte mucho con la función de equipment, ¿función genérica?
func get_random_skill_list(size: int = 1) -> Array[SkillData]:
	var list: Array[SkillData] = skills.list.duplicate()
	var picks: int = min(size, list.size())
	var chosen_list: Array[SkillData] = []
	for i in range(picks):
		var chosen_skill = list.pick_random()
		if chosen_skill != null:
			chosen_list.append(chosen_skill)
			list.erase(chosen_skill)
	return chosen_list
	
# Probablemente sustituir por herencia.
func add(element):
	if element is SkillData:
		add_skill(element)
	elif element is Equipment:
		add_equipment(element)
		
func add_skill(skill: SkillData):
	skills.list.append(skill)

func add_equipment(equipment: Equipment):
	equipments.list.append(equipment)

func remove_equipment(equipment: Equipment):
	equipments.list.erase(equipment)

func remove_skill(skill: SkillData):
	skills.list.erase(skill)

func remove(element):
	if element is SkillData:
		remove_skill(element)
	elif element is Equipment:
		remove_equipment(element)
		

func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
	}
	# Guarda y carga por nombre del archivo de los recursos.
	# TEMPORAL? Necesario cambiarlo para poder aceptar múltiples objetos iguales.
	var equipment_paths: Array[String] = []
	var skill_paths: Array[String] = []
	for equipment in equipments.list:
		equipment_paths.append(equipment.resource_path)
	for skill in skills.list:
		skill_paths.append(skill.resource_path)
	save_dict["equipments"] = equipment_paths
	save_dict["skills"] = skill_paths
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
	else:
		set(parameter, data)
