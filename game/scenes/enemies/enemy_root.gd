extends RigidBody2D

onready var enabler = get_node("enabler")
var isActive = false

func _ready():
	enabler.connect("enter_screen",self,"on_enabler_enter")
	enabler.connect("exit_screen",self,"on_enabler_exit")
	set_fixed_process(false)
	
func on_enabler_enter(): 
	isActive = true
	set_fixed_process(true)
	


func on_enabler_exit(): 
	isActive = false
	set_fixed_process(false)

func _fixed_process(delta):

	