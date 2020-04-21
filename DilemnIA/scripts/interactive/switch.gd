extends MeshInstance

export var obj_name = "Unnamed"
export var state = false
var root = null
var animation_isplaying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_root().get_node("Game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
			

func pressed():
	state = !state
	if(state == true):
		#print("Turn " + switch_name + " on")
		get_node("animation").play("yes")
		root.get_node("Audio/switch_on").play()
	else:
		#print("Turn " + switch_name + " off")
		get_node("animation").play("no")
		root.get_node("Audio/switch_off").play()

func unpressed():
	pass

func name():
	return obj_name
