class_name AttackState extends State

## Attack & deal damage to the target character

@onready var visual_actions:VisualActions = $VisualActions
@onready var attack_actions:AttackActions = $AttackActions


func on_entry():
	pass


func on_exit():
	pass


func on_active():
	visual_actions.face_point(target_character.position)
	visual_actions.play_animation("attacking")
	attack_actions.melee()
