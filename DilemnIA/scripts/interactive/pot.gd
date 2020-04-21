extends MeshInstance

export var obj_name = "Unnamed"
var state = 0.0

export var rotation_speed = 1000
var pot_inuse = false
var camera = null
var crosshair = null
var root = null

func map(x, in_min, in_max, out_min, out_max):
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_root().get_node("Game")
	camera = root.get_node("Camera")
	crosshair = root.get_node("Control/Crosshair")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if(pot_inuse):
		if event is InputEventMouseMotion:
			if self.rotation[1] >= -2.5 && self.rotation[1] <= 2.5:
				state = map(self.rotation[1], 2.5, -2.5, 0, 1)
				self.rotate_y(event.relative[1] / 1000)
			else :
				if self.rotation[1] >= -2.5 :
					self.rotation[1] = 2.5
				else:
					self.rotation[1] = -2.5
			#print(state)


func pressed():
	camera.mouselook = false
	crosshair.visible = false
	pot_inuse = true
	set_process_input(true)

func unpressed():
	camera.mouselook = true
	crosshair.visible = true
	pot_inuse = false
	set_process_input(false)

func name():
	return obj_name
