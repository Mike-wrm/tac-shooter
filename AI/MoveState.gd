extends State

## Navigate toward the set target position

@onready var move_actions:MoveActions = $MoveActions
@onready var visual_actions:VisualActions = $VisualActions

func on_entry():
	pass
	

func on_exit():
	move_actions.stop_navigation()


# Pathfind towards our target every physics frame
func on_active():
	move_actions.navigate_to_point(movement_target)
	visual_actions.face_forward()
	visual_actions.play_animation("walking")
