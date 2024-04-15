extends Resource
class_name Cost

func can_pay(_user) -> bool:
	return true
	
func pay(_user):
	pass

func get_description() -> String:
	return "Dummy cost"
