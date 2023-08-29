class_name AttackActions extends Action

@export var attack_range:float = 100.0

var aiming_master:AimingMaster:
	get:
		return my_character.aiming_master

# TODO: to damage to player
func melee():
	pass
