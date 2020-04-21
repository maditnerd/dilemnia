extends MeshInstance

export var obj_name = "Unnamed"
export var gauge_overfilled = -1.85
export var gauge_filled = -1.8
export var gauge_middle = -0.75
export var gauge_empty = 0.048

var state = 0

var timer = null
var movement_delay = 0.01
var movement_increment = 0
var movement = false
var direction = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_wait_time(movement_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)
	fill()


func test():
	update_increment(1.0)
	print(movement_increment)
	fill()

func on_timeout_complete():
	if(movement == true):
		var t = get_transform()
		#print(t.origin.z)
		if(direction == true):
			
			t.origin.z -= movement_increment
			
			if(t.origin.z <= gauge_overfilled ):
				t.origin.z = gauge_overfilled
				# print(obj_name + " overfilled")
				state = -1
				movement = false
				timer.stop()
			elif(t.origin.z < gauge_middle - 0.20 && t.origin.z >= gauge_overfilled):
				# print(obj_name + "not middle anymore")
				if(state == 50):
					state = -1
			elif(t.origin.z <= gauge_middle && t.origin.z >= gauge_middle - 0.20):
				# print(obj_name + " middle")
				state = 50
		else:
			t.origin.z += movement_increment
			
			if(t.origin.z >= gauge_empty):
				state = 0
				movement = false
				timer.stop()
				print(obj_name + " empty")
				movement_increment = 0
				fill()
		set_transform(t)


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	pass

func fill():
	movement = true
	direction = true
	timer.start()

func empty():
	print("START EMPTY")
	movement_increment = 1
	movement = true
	direction = false
	timer.start()

func stop():
	movement = false
	timer.stop()

func update_increment(new_increment):
	movement_increment = new_increment / 100

