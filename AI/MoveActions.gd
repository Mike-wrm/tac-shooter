class_name MoveActions extends Action

## ABSTRACT CLASS
## A library of functions to move characters in the level

var pathfinding_master:PathfindingMaster:
	get: return my_character.pathfinding_master
var movement_master:MovementMaster:
	get: return my_character.movement_master


# Pathfind to a point
func navigate_to_point(movement_target:Vector2):
	var nav_pos:Vector2
	
	# Move to the next path node at max speed:
	pathfinding_master.target_pos = movement_target
	nav_pos = pathfinding_master.next_nav_pos 
	movement_master.move_to_point(nav_pos) 
	
	# If using avoidance, feed it this "raw" velocity. See PathfindingMaster.init_nav_avoidance() 
	# for additional documentation. 
	if pathfinding_master.nav_avoidance:
		pathfinding_master.nav_velocity = my_character.velocity


# Immediately stops character movement and sets pathfinding to done
func stop_navigation():
	my_character.movement_master.move_along(Vector2.ZERO)
	pathfinding_master.target_pos = my_character.position
	pathfinding_master.update_path()
