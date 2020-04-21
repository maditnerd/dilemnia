extends Spatial
export var MOUSE_DETECTION_LENGTH = 1000

var left_click_pressed = false
var object_pressed = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	var object_under_mouse = get_object_under_mouse()

	if object_under_mouse:
		if Input.is_action_pressed("left_click"):
			if(left_click_pressed == false):
				object_under_mouse.collider.get_parent().pressed()
				object_pressed = object_under_mouse
				left_click_pressed = true
				get_node("Logic").check_interaction(object_under_mouse.collider.get_parent(), true)
	
	if object_pressed:	
		if(left_click_pressed == true):
			if Input.is_action_just_released("left_click"):
				left_click_pressed = false
				object_pressed.collider.get_parent().unpressed()
				get_node("Logic").check_interaction(object_pressed.collider.get_parent(), false)
				object_pressed = null
				
# Check if an object is under the mouse
# Based on DogPot answer on reddit - https://www.reddit.com/r/godot/comments/8ft84k/get_clicked_object_in_3d/
func get_object_under_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_from = $Camera.project_ray_origin(mouse_pos)
	var ray_to = ray_from + $Camera.project_ray_normal(mouse_pos) * MOUSE_DETECTION_LENGTH
	var space_state = get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
