extends Node2D

var weapon : Gun : 
	get: return get_parent()
	
@export var max_reload_time:float = 1.0 # [sec]
	
# Perfect reload vars as a proportion of max_reload_time:
@export var perfect_zone_length:float = 0.15 # Arc length of the perfect reload zone
@export var perfect_zone_min_pos:float = 0.25 # The soonest the perfect zone can appear

# Variables for reload tracking
var is_reloading:bool = false
var time_spent_reloading:float = 0.0
var perfect_zone_pos:float # Current position of the perfect zone as a proportion of max_reload_time
var reload_failed:bool = false

var magazine : Magazine :
	get: return weapon.magazine
	set(mag): weapon.magazine = mag
	
var magazine_selected_for_reload : Magazine = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if weapon.is_equipped():
		handle_reloading(delta)

func handle_reloading(delta):
	# Accept mag inserts near the end of the perfect zone as a proportion of max_reload_time
	var late_forgiveness := 0.02
	
	if is_reloading:
		time_spent_reloading += delta
		
		if not reload_failed: # Too late
			reload_failed = time_spent_reloading > max_reload_time \
					* (perfect_zone_pos + perfect_zone_length + late_forgiveness)
		
		if time_spent_reloading >= max_reload_time: # Reload timed out
			finish_reload()
	
# Called whenever the reload key is pressed
func reload():
	if not is_reloading:
		if weapon.has_magazine_loaded(): # Eject
			weapon.eject_mag()
		else: # If Magazine ejected, we attempt to start a reload
			attempt_start_reload()
	else:
		attempt_active_reload()
		
# Searches the character's inventory for the compatible magazine with the most
# bullets currently inside of it and returns it if it exists
func find_reload_magazine():
	magazine_selected_for_reload = null # resetting the selected mag
	var item_list = weapon.get_weapon_wielder().inventory.get_items()
	
	for my_item in item_list:
		if my_item is Magazine:
			if my_item.is_compatible_with_gun(weapon):
				if magazine_selected_for_reload == null:
					magazine_selected_for_reload = my_item
				elif magazine_selected_for_reload.current_quantity < my_item.current_quantity:
					magazine_selected_for_reload = my_item 
		
# Attempt to find a mag to reload with, and start the reload if one is found
func attempt_start_reload():
	# Repacking automatically based on difficulty
	if DifficultyMaster.auto_mag_repack:
		for ammo_type in weapon.compatible_ammo_types:
			weapon.get_weapon_wielder().inventory.magazine_repack_for_ammo_type(ammo_type)
	
	find_reload_magazine()
	
	# If we've found a magazine, start reloading
	if magazine_selected_for_reload != null:
		is_reloading = true
		perfect_zone_pos = randf_range(perfect_zone_min_pos, 1.0 - perfect_zone_length)

# Manual reload attempted
func attempt_active_reload():
	if not reload_failed: # Only get one chance!
		reload_failed = time_spent_reloading < (max_reload_time * perfect_zone_pos) # Too soon
		if not reload_failed:
			finish_reload()
			
func finish_reload():
	# Insert the mag we selected when we started the reload
	if magazine_selected_for_reload != null:
		weapon.insert_mag(magazine_selected_for_reload)
	magazine_selected_for_reload = null
	is_reloading = false
	time_spent_reloading = 0.0
	reload_failed = false
	
func get_reload_progress() -> float:
	return (time_spent_reloading/max_reload_time)*100.0
