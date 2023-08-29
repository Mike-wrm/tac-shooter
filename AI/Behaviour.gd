class_name Behaviour extends Node2D

## The "top-level" class for all things AI behavioural control. Use (concrete) extensions of this
## class as nodes in an AI's scene tree. The Behaviour scene tree is as follows:
## Behaviour
## -State
## --Action
## -Link

## ABSTRACT CLASS
## See documentation here: https://drive.google.com/file/d/1B7M7hS6DAf53DmyjilamFfWFmnEXBJkw/view?usp=sharing
## A Behaviour is an abstraction of a FSM (finite state machine), consisting of states. A state has
## any number of actions on entry, exit, and while it is active. States are connected by conditional
## directional links. Behavioiur.update() runs every physics frame, and by extension, State actions.

var my_character:Character:
	get: return get_parent()
var target_character:Character # Only needs to be set once
var movement_target:Vector2 # Must be updated every physics frame, since Vector2 is passed by value
var current_state:State
var initial_state:State:
	set(new_state):
		initial_state = new_state
		current_state = initial_state


# Put any additional setup here, such as setting targets
func _ready():
	init_fsm()


func _physics_process(delta):
	update()
	

# PRIVATE ABSTRACT FUNCTION
# Connect states and links according to your FSM diagram here
func init_fsm():
	# States:
	# ...
	# Links:
	# ...
	# Attach destination states to links:
	# ...
	# Attach links to source states:
	# ...
	# Set initial state:
	# ...
	pass

# PUBLIC VIRTUAL FUNCTION
# Updates the FSM every physics frame. This includes executing actions and transitioning between 
# states
func update():
	for link in current_state.links: # State transitions are "first come first serve"
		# on_exit ---change_state---> on_entry:
		if link.triggered: 
			current_state.ended = true
			current_state.execute()
			current_state = link.next_state
			'''
			# For debugging use
			print("Changing state to %s" % current_state)
			'''
			break
	
	current_state.execute()
