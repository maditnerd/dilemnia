extends MeshInstance

export var obj_name = "Unnamed"
var state = "black"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var material = null
var turn_done = false
var emission_delay = 0.01
var emission_increment = 0.01
var timer_set = false
var timer = null
var turn_state = false


# Called when the node enters the scene tree for the first time.
func _ready():
	material = self.get_mesh().surface_get_material(0)
	material.set_emission(Color(ColorN("black")))

	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_wait_time(emission_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)

# Create a timer : https://www.youtube.com/watch?v=4Dj6vaatONI
func turn(new_state):
	#print(obj_name + "go to ", new_state)
	turn_done = false
	turn_state = new_state
	if(turn_state == true):
		material.set_emission_energy(0)
	timer.start()
	

func on_timeout_complete():
	var energy = material.get_emission_energy()
	if(turn_state == true):
		material.set_emission_energy(energy + emission_increment)
		if(energy >=1):
			#print(obj_name + " turned on")
			turn_done = true
			timer.stop()
	else:
		material.set_emission_energy(energy - emission_increment)
		if(energy <=0):
			#print(obj_name + " turned off")
			turn_done = true
			material.set_emission(Color(ColorN("black")))
			material.set_emission_energy(1)
			timer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_state(color):
	material.set_emission(Color(ColorN(color)))
