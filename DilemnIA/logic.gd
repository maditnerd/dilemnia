extends Node
var root = null
export var path_machine = "machine"
export var path_powerpanel = "powerpanel"

var stage = 0
var state = 0
var modifier_state = false
var modifier2_state = false

var shutdown_in_progress = false

# Display
var led_power = null
var led_01 = null
var led_02 = null
var led_03 = null
var led_04 = null

# Procedure
var BRK = null
var ATL = null
var THB = null
var ORZ = null
var HEV = null
var DAB = null
var JAR = null

# Functions
var func1 = null
var func2 = null
var func3 = null
var func4 = null

var check_led_power = false
var check_led = false
var err_screen = null
# Gauges
var check_dab = false
var pot_dab = null
var gauge_dab = null

var check_jar = false
var pot_jar = null
var gauge_jar = null

# Power Control
var exp_power = null

# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_tree().get_root().get_node("Game")
	pot_dab = root.get_node(path_machine + "/gauges/DAB/pot")
	gauge_dab = root.get_node(path_machine + "/gauges/Gauge_DAB/cursor")
	pot_jar = root.get_node(path_machine + "/gauges/JAR/pot")
	gauge_jar = root.get_node(path_machine + "/gauges/Gauge_JAR/cursor")
	exp_power = root.get_node(path_powerpanel + "/EXPPOWER/switch")
	led_power = root.get_node(path_machine + "/display/led_power")
	err_screen = root.get_node(path_machine + "/display/screen")
	led_01 = root.get_node(path_machine + "/display/led01")
	led_02 = root.get_node(path_machine + "/display/led02")
	led_03 = root.get_node(path_machine + "/display/led03")
	led_04 = root.get_node(path_machine + "/display/led04")
	func1 = root.get_node(path_machine + "/functions/FUNC1")
	func2 = root.get_node(path_machine + "/functions/FUNC2")
	func3 = root.get_node(path_machine + "/functions/FUNC3")
	func4 = root.get_node(path_machine + "/functions/FUNC4")
	BRK = root.get_node(path_machine + "/procedures/BRK/switch")
	ATL = root.get_node(path_machine + "/procedures/ATL/switch")
	THB = root.get_node(path_machine + "/procedures/THB/switch")
	ORZ = root.get_node(path_machine + "/procedures/ORZ/switch")
	HEV = root.get_node(path_machine + "/procedures/HEV/switch")
	
	randomize()
	var random = randi()%2
	if(random == 1):
		modifier_state = true
	var random2 = randi()%2
	if(random2 == 1):
		modifier2_state = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(check_dab):
		gauge_dab.update_increment(pot_dab.state)
	if(check_jar):
		gauge_jar.update_increment(pot_jar.state)
	if(check_led_power):
		if(led_power.turn_done):
			if(exp_power.state):
				print("Expérience allumé")
				print("STATE=1")
				check_led_power = false
				root.get_node("Audio/machine_on").play()
				state = 1
			else:
				print("Expérience éteint")
				check_led_power = false
				print("STATE=0")
				shutdown_in_progress = false
				state = 0
				
		
func check_interaction(node, active):
	if(node.name() == "EXPPOWER" && active):
		if(node.state):
			print("Allumage de l'expérience")
			led_power.change_state("red")
			led_power.turn(true)
			check_led_power = true
		else:
			print("Extinction de l'expérience")
			err_screen.change_message(0)
			root.get_node("Audio/error").stop()
			led_power.turn(false)
			led_01.turn(false)
			led_02.turn(false)
			led_03.turn(false)
			led_04.turn(false)
			shutdown_in_progress = true
			check_led_power = true
	elif(node.name() == "OXYGEN"):
		get_tree().quit()
	elif(state != 0 && active && node.name() == "ETA"):
			gauge_dab.empty()
	elif(state != 0 && active && node.name() == "ETB"):
			gauge_jar.empty()
	elif(state == 1 && active):
		var ok = false
		if(stage == 0 && node.name() == "FUNC1"):
			ok = true
		if(stage == 1 && node.name() == "FUNC2"):
			ok = true
		if(ok):
			if(!modifier_state):
				led_03.change_state("red")
				led_03.turn(true)
				print("STATE=2")
				state = 2
				
			led_01.change_state("red")
			led_01.turn(true)
			led_02.change_state("red")
			led_02.turn(true)
			led_04.change_state("red")
			led_04.turn(true)
			
			
			
		else:
			if(!modifier_state):
				bad_input(node.name())
			else:
				if(node.name() == "BRK" || node.name() == "ATL" || node.name() == "THB" || node.name() == "ORZ" || node.name() == "HEV" && active):
					print("COND")
					if(BRK.state && ORZ.state && HEV.state && !ATL.state && !THB.state):
						print("OK")
						state = 2
						led_03.change_state("red")
						led_03.turn(true)
				else:
					bad_input(node.name())				
	elif(state == 2 && active):
		var ok = false
		if(stage == 0 && node.name() == "THB" && THB.state):
			ok = true
		if(stage == 1 && node.name() == "ATL" && THB.state):
			ok = true
		if(ok):
			led_01.change_state("green")
			led_02.change_state("green")
			led_03.change_state("green")
			led_04.change_state("green")
			state = 3
		else:
			bad_input(node.name())
	elif(state == 3 && active):
		check_dab = true
		check_jar = true
		if(node.name() == "JAR" || node.name() == "DAB" || node.name() == "BRK" || node.name() == "ATL" || node.name() == "THB" || node.name() == "ORZ" || node.name() == "HEV" && active):
			var ok = false
			var ok2 = false
			if(modifier_state):
				if(BRK.state && ORZ.state && HEV.state && !ATL.state && !THB.state):
					ok = true
			else:
				if(ORZ.state && !THB.state):
					ok = true

			if(ok):
				if(stage == 0):
					if(gauge_jar.state == 50):
						ok2 = true
					else:
						bad_input("JARGAUGE")
				else:
					if(gauge_dab.state == 50):
						ok2 = true
					else:
						bad_input("DABGAUGE")
				if(ok2):
					state = 4 
					check_dab = false
					check_jar = false
					led_02.turn(false)
					led_03.turn(false)
					led_01.change_state("orange")
					led_04.change_state("orange")
				else:
					bad_input(node.name())
		else:
			bad_input(node.name())
	elif(state == 4 && active):
		if(!BRK.state && !ATL.state && !THB.state && !ORZ.state && !HEV.state):
			if(stage == 0):
				stage = 1
			elif(stage == 1):
				stage = 2
				print("FIN DU JEU")
			state = 1
			led_01.turn(false)
			led_02.turn(false)
			led_03.turn(false)
			led_04.turn(false)
			THB = root.get_node(path_machine + "/procedures/ATL/switch")
			ATL = root.get_node(path_machine + "/procedures/THB/switch")
			func1 = root.get_node(path_machine + "/functions/FUNC2")
			func2 = root.get_node(path_machine + "/functions/FUNC1")
			modifier_state = !modifier_state
			modifier2_state = !modifier2_state
			if(stage == 1):
				root.get_node("Audio/music2").play()
				root.get_node("Audio/music").stop()
			if(stage == 2):
				root.get_node("Audio/music2").stop()
				root.get_node("Audio/music").stop()

func bad_input(name):
	if(!shutdown_in_progress):
		print("STATE=-1")
		print("BadInput: ", name)
		root.get_node("Audio/error").play()
		state = -1
		err_screen.change_message(1)
