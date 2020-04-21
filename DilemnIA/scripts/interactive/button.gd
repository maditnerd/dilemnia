extends MeshInstance

export var obj_name = "Unnamed"
var root = null
var state = false
var animation_isplaying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_root().get_node("Game")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
			

func pressed():
	state = true
	get_node("AnimationPlayer").play("yes")
	root.get_node("Audio/button_on").play()

func unpressed():
	state = false
	get_node("AnimationPlayer").play("no")
	root.get_node("Audio/button_off").play()
	
func name():
	return obj_name
