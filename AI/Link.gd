class_name Link extends Node2D

## Refer to Behaviour.gd for FSM documentation

## ABSTRACT CLASS
## Contains a library of conditional tests. Extend this class and combine whatever conditional
## tests you'd like in is_triggered()

var next_state:State
var triggered:bool:
	get: return is_triggered()
var target_character:Character:
	get: return (get_parent() as Behaviour).target_character
var my_character:Character:
	get: return (get_parent() as Behaviour).my_character 
var pathfinding_master:PathfindingMaster:
	get: return my_character.pathfinding_master


# VIRTUAL FUNCTION
# Have all our conditional tests been met? Can we proceed to the next state?
func is_triggered() -> bool:
	return false
	
	
# ----------------------------------------------- CONDITIONAL TESTS

# Is the target reachable/in the same room as my_character?
func target_valid() -> bool:
	pathfinding_master.target_pos = target_character.position
	return pathfinding_master.target_pos_reachable
	

# TODO: is the target within our vision cone?
func target_seen() -> bool:
	return true
	

# TODO: are we in-range, have line-of-sight, and have ammo to attack the target?
func can_engage_target() -> bool:
	var target_distance = my_character.position.distance_to(target_character.position)
	return target_distance <= my_character.attack_range


# TODO: was noise made within our hearing radius?
func target_heard() -> bool: 
	return true
	
	
# Did we reach our destination?
func navigation_done() -> bool:
	return pathfinding_master.nav_done
	
# ----------------------------------------------- CONDITIONAL TESTS END
