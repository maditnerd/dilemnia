extends MeshInstance

export var obj_name = "Unnamed"
var state = 0
var message = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	message = get_node("message")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func change_message(number):
	message.set_frame(number)
	state = number

	
