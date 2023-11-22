extends SkillData
class_name CoinSkillData

@export var rerolls: int = 0
@export var ephemeral_coins: int = 0
@export var facing = 0

func _init():
	pass

func get_description() -> String:
	var description: String = ""
	var facing_text: String
	match facing:
		0: facing_text = "(Flip)"
		1: facing_text = "(Heads)"
		2: facing_text = "(Tails)"
	if rerolls > 0:
		var plural = "" if rerolls == 1 else "s"
		if description != "": description += "\n"
		description += "%d Reroll%s %s" % [rerolls, plural, facing_text]
	if ephemeral_coins > 0:
		var plural = "" if rerolls == 1 else "s"
		if description != "": description += "\n"
		description += "%d Extra Coin%s %s" % [ephemeral_coins, plural, facing_text]
	return description

func create_skill(user, target, coins) -> Skill:
	return CoinSkill.new(self, user, target, coins)
