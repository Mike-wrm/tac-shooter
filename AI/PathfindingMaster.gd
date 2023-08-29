class_name PathfindingMaster extends Node2D

## Abstracts the details of pathfinding and behaviour

@export var nav_max_speed:float = 300.0 # Should be the same as MovementMaster.max_speed
@export var nav_timeout_interval:float = 0.5 # How often should pathfinding be run? [sec]

@onready var nav_agent = $NavigationAgent2D
@onready var nav_timer:Timer = $NavTimer

var my_character:Character:
	get: return get_parent()
	
# TODO: avoidance may not work correctly and should be tested before use
var nav_avoidance:bool: # Avoid other pathfinding characters?
	get: return nav_agent.avoidance_enabled
var target_pos:Vector2 # Must explicitly call update_path() to generate a new path
var next_nav_pos:Vector2
var nav_done:bool: # Have we reached the target_pos?
	get: return nav_agent.is_navigation_finished()
var target_pos_reachable:bool: # Must set a target_pos first
	get: 
		assert(target_pos != null, "PathfindingMaster.target_pos_reachable: target_pos not set")
		update_path()
		return nav_agent.is_target_reachable()
var nav_velocity:Vector2: # Update this every physics frame, if using avoidance
	set(velocity): nav_agent.set_velocity(velocity)


func _ready():
	nav_timer.wait_time = nav_timeout_interval
	nav_timer.timeout.connect(update_path)
	nav_agent.max_speed = nav_max_speed
	nav_agent.avoidance_enabled = nav_avoidance
	nav_agent.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_EDGECENTERED


func _physics_process(delta):
	next_nav_pos = nav_agent.get_next_path_position()


# Every physics frame, you need to feed nav_agent a "raw" velocity of where you want to go via
# NavigationAgent.velocity. This velocity is automatically adjusted and passed as an argument to a 
# callback function to actually move the character. Set that callback function here: most likely a 
# MovementMaster function. 
#
# avoidance_radius is distance from the character in [px] where it begins to avoid other characters
func init_nav_avoidance(func_name:Callable, nav_radius:float):
	nav_agent.avoidance_enabled = true
	nav_agent.radius = nav_radius
	nav_agent.velocity_computed.connect(func_name)


# NavTimer callback: periodically create a new path with the same target
func update_path():
	nav_agent.set_target_position(target_pos)
